function wiki --description "Open or append to the personal LLM wiki (works from any directory)"
    set -l dir "$HOME/workspace/personal/wiki"
    if not test -d "$dir"
        echo "wiki: not found at $dir — run: mise run wiki:install" >&2
        return 1
    end
    # Run in the wiki dir so its CLAUDE.md (maintainer rules) auto-loads; pushd/popd
    # keeps your current directory unchanged.
    pushd "$dir" >/dev/null
    if test (count $argv) -eq 0
        claude
    else
        claude -p "Maintain this wiki following CLAUDE.md. Apply this update, creating or linking pages and updating index.md as the policy requires: $argv"
    end
    popd >/dev/null
end
