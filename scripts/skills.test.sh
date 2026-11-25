#!/usr/bin/env bash
# Tests for scripts/skills. Each case runs with a temporary HOME and stub
# npx, claude and codex commands on PATH, so nothing real is installed.
#
#   scripts/skills.test.sh
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_root/scripts/skills"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

failures=0
fail() {
  echo "FAIL: $*" >&2
  failures=$((failures + 1))
}

stub_bin="$work/bin"
mkdir -p "$stub_bin"
for cmd in npx claude codex; do
  cat >"$stub_bin/$cmd" <<EOF
#!/usr/bin/env bash
echo "$cmd \$*" >>"\$STUB_LOG"
EOF
  chmod +x "$stub_bin/$cmd"
done

# A mise shim reads config under HOME, so it breaks once HOME is temporary.
# Link a real jq binary in front of it.
real_jq=""
IFS=: read -ra path_dirs <<<"$PATH"
for dir in "${path_dirs[@]}"; do
  case "$dir" in */mise/shims) continue ;; esac
  if [ -x "$dir/jq" ]; then
    real_jq="$dir/jq"
    break
  fi
done
[ -n "$real_jq" ] || real_jq="$(mise which jq 2>/dev/null || true)"
if [ -z "$real_jq" ]; then
  echo "skills.test: jq not found outside mise shims" >&2
  exit 1
fi
ln -s "$real_jq" "$stub_bin/jq"

base_manifest() {
  cat <<'EOF'
{
  "agents": ["claude-code"],
  "skillsCli": "1.9.0",
  "plugins": {
    "claude": {
      "marketplaces": ["owner/market"],
      "install": ["one@market"]
    }
  },
  "lockVersion": 1,
  "skills": {
    "alpha": {"source": "owner/repo", "sourceType": "github", "commit": "aaa"}
  }
}
EOF
}

# run_install <case-name> <manifest-json>: sets case_dir, out, status.
run_install() {
  case_dir="$work/$1"
  mkdir -p "$case_dir/home"
  printf '%s\n' "$2" >"$case_dir/manifest.json"
  : >"$case_dir/stub.log"
  status=0
  out="$(HOME="$case_dir/home" PATH="$stub_bin:$PATH" STUB_LOG="$case_dir/stub.log" \
    SKILLS_MANIFEST="$case_dir/manifest.json" "$script" install 2>&1)" || status=$?
}

# A valid manifest installs skills and plugins.
run_install valid "$(base_manifest)"
[ "$status" -eq 0 ] || fail "valid: exit $status: $out"
grep -q '^claude plugin install one@market$' "$case_dir/stub.log" || fail "valid: plugin not installed"
grep -q '^npx --yes skills@1.9.0 install' "$case_dir/stub.log" || fail "valid: skills not restored"
[ ! -e "$case_dir/home/skills-lock.json.bak" ] || fail "valid: unexpected backup"

# A malformed plugins section stops before anything is installed.
malformed() {
  local name="$1" filter="$2"
  run_install "$name" "$(base_manifest | jq "$filter")"
  [ "$status" -ne 0 ] || fail "$name: exit 0"
  case "$out" in
    *"every declared skill and plugin is installed"*) fail "$name: printed success" ;;
  esac
  [ ! -s "$case_dir/stub.log" ] || fail "$name: ran $(cat "$case_dir/stub.log")"
}
malformed plugins-string '.plugins = "claude"'
malformed plugins-number '.plugins = 3'
malformed cli-string '.plugins.claude = "one@market"'
malformed install-string '.plugins.claude.install = "one@market"'
malformed marketplaces-string '.plugins.claude.marketplaces = "owner/market"'
malformed install-non-string-item '.plugins.claude.install = [1]'

# A home lock whose pins differ from the manifest is kept as a backup.
case_dir="$work/updated-pin"
mkdir -p "$case_dir/home"
updated='{"version": 1, "skills": {"alpha": {"source": "owner/repo", "sourceType": "github", "commit": "bbb"}}}'
printf '%s\n' "$updated" >"$case_dir/home/skills-lock.json"
run_install updated-pin "$(base_manifest)"
[ "$status" -eq 0 ] || fail "updated-pin: exit $status: $out"
if [ -f "$case_dir/home/skills-lock.json.bak" ]; then
  [ "$(jq -r '.skills.alpha.commit' "$case_dir/home/skills-lock.json.bak")" = bbb ] ||
    fail "updated-pin: backup does not hold the updated pin"
else
  fail "updated-pin: no backup"
fi
[ "$(jq -r '.skills.alpha.commit' "$case_dir/home/skills-lock.json")" = aaa ] ||
  fail "updated-pin: home lock not replaced with the manifest pins"

# A home lock that jq cannot parse is kept as a backup.
case_dir="$work/unparsable"
mkdir -p "$case_dir/home"
printf 'not json\n' >"$case_dir/home/skills-lock.json"
run_install unparsable "$(base_manifest)"
[ "$status" -eq 0 ] || fail "unparsable: exit $status: $out"
[ "$(cat "$case_dir/home/skills-lock.json.bak" 2>/dev/null)" = "not json" ] ||
  fail "unparsable: raw lock not kept"

# A home lock that matches the manifest, in any key order, is not backed up.
case_dir="$work/same"
mkdir -p "$case_dir/home"
printf '%s\n' '{"skills": {"alpha": {"commit": "aaa", "sourceType": "github", "source": "owner/repo"}}, "version": 1}' \
  >"$case_dir/home/skills-lock.json"
run_install same "$(base_manifest)"
[ "$status" -eq 0 ] || fail "same: exit $status: $out"
[ ! -e "$case_dir/home/skills-lock.json.bak" ] || fail "same: unexpected backup"

if [ "$failures" -ne 0 ]; then
  echo "$failures failure(s)" >&2
  exit 1
fi
echo "scripts/skills: all tests passed"
