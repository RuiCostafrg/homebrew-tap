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

Push your commits first: `gh signoff` only attests pushed work. Failing stages post
a red `signoff/<stage>` status automatically. Each status (green or red) is bound
with `--commit` to the exact commit captured at the start of its stage, so a
commit or push landing mid-run can never be green-lit for code it did not test.
a red `signoff/<stage>` status automatically.

## Optional: make sign-off a merge requirement

```bash
gh signoff install workflows       # or: gh signoff install workflows install
gh signoff uninstall
```

## Notes

- `workflows` checks every `.github/workflows/*.yml` with actionlint, so
  `sync.yml` is covered too.
- The `install` stage builds against your local tap checkout rather than fetching
  the pushed tap ref as CI does; run it as a final acceptance check.
