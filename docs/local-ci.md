# Local CI — `gh-signoff` (Linux only)

Run the tap checks on your own machine and post green `signoff/<stage>` commit
statuses with [basecamp/gh-signoff](https://github.com/basecamp/gh-signoff).

Use it when free Actions minutes run out — or as a fast pre-push gate. The GitHub
Actions workflows stay untouched; this lane covers **Linux only** (CI also runs a
macOS install matrix, which stays hosted).

## Setup (Linux)

```bash
gh auth login
gh extension install basecamp/gh-signoff
```

Toolchains: `curl`, `ruby`; `actionlint` (auto-downloaded pinned v1.7.12 on
x86_64, checksum-verified, same as CI); Homebrew-on-Linux for the optional
`install` stage.

## Usage

```bash
scripts/local-ci.sh                # stages: workflows (actionlint + formula syntax)
scripts/local-ci.sh install        # brew-install the formula only (skips the workflows stage)
scripts/local-ci.sh --no-signoff   # checks only, no statuses posted
```

Commit and push your changes before signing off. The runner rejects a dirty
checkout before running checks, verifies that HEAD and the worktree remain
stable, and posts to the tested commit. A failed stage attempts to post a red
`signoff/<stage>` status. Use `--no-signoff` to check local edits.

The runner and checksum are vendored from verified-release-kit. The tap
defines its local checks in `scripts/local-ci.stages.sh`.

## Optional: make sign-off a merge requirement

```bash
gh signoff install workflows       # or: gh signoff install workflows install
gh signoff uninstall
```

## Notes

- `workflows` checks every `.github/workflows/*.yml` with actionlint, so
  `sync.yml` is covered too.
- The `install` stage loads the formulas by name from the Homebrew checkout. Run
  it from `$(brew --repository RuiCostafrg/tap)` in a disposable Homebrew prefix
  with neither formula installed. For a differently named local tap, set
  `LOCAL_CI_BREW_TAP` to its name. The runner verifies that Homebrew points to
  the same checkout before installing either formula.
