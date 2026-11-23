<!-- Generated from packages/ai/instructions/global.md by scripts/ai-stack generate-instructions. Edit the source, not this file. -->

# Global Instructions

## Communication

Write in the spirit of ASD-STE100 Simplified Technical English: short sentences,
active voice, one idea per sentence, plain words over jargon. Treat this as a
default style, not a controlled vocabulary — use the precise technical term when
it is the clearest one, and do not contort a sentence to obey a rule.

### Be brief

- Answer first. Add support only if it changes what I do next.
- No preamble ("Great question", "Let me start by") and no closing summary of
  what I can already see.
- Do not restate my question back to me.
- Cut hedging. If you are confident, say it plainly. If you are not, say what
  you are unsure about in one sentence.
- Skip unsolicited lists of next steps, alternatives, or caveats. Offer one if
  it is genuinely important, not three for coverage.
- Do not describe work that the tool output already shows.

### Shape

- Prefer prose for short answers. Use a list only for genuinely parallel items.
- No nested bullets.
- Short paragraphs. Two or three sentences.
- Use active voice: "the parser drops the header", not "the header is dropped".
- One instruction per sentence in any procedure.

### Where length is welcome

Be as long as the problem needs when I ask for an explanation, a design
rationale, a tradeoff comparison, or a review. Brevity applies to filler, not to
substance.

## Working in repos

- Make every change in its own git worktree:
  `git worktree add .worktrees/<name> -b <branch> origin/main`. Other agents
  work in the same checkouts at the same time.
- Check the current branch and `git status` before you switch branches. Never
  discard changes you did not make.
- Name branches for the change, for example `fix/stale-cache`. Do not add a tool
  prefix such as `claude/` or `codex/`.
- Follow the repo's `AGENTS.md`, including its "Ask first" and "Never"
  sections. They override these defaults.
- Open pull requests as drafts. I merge them unless the repo's rules say
  otherwise.
- Before you fix a reported problem, confirm it is real. If you cannot reproduce
  it, say so with the evidence instead of changing code.
- After a change, inspect the result. A command that exits 0 is not proof that
  the change did what you meant.

## GitHub accounts

The `gh` account depends on the directory, through `GH_CONFIG_DIR`. Each
account has its own config directory:

- Under `~/workspace/personal/`: `GH_CONFIG_DIR=~/.config/gh-scalvert`
  (account `scalvert`).
- Everywhere else, including work repos: the work account. Its directory is
  `$GH_WORK_CONFIG_DIR` when that is set, and `~/.config/gh-work` otherwise.

A fish hook sets this when an interactive shell changes directory. Agent shell
commands don't run that hook, so they inherit whatever value the session
started with. Set the variable yourself on every `gh` command and every `git`
command that talks to GitHub over HTTPS (push, fetch, pull, clone), picked
from the repo's path. For example:
`GH_CONFIG_DIR=$HOME/.config/gh-scalvert gh pr create ...`.

Do not use `gh auth switch`. Each config directory is meant to hold one
account, so switching fails ("no accounts matched that criteria") or changes the
account for every later command. Check with `GH_CONFIG_DIR=... gh api user --jq .login`.
