#!/usr/bin/env bash
# homebrew-tap local CI — Linux only, powered by basecamp/gh-signoff.
# Mirrors .github/workflows/ci.yml (workflows job: actionlint + formula syntax;
# install job: brew install of the formula).
# Usage:
#   scripts/local-ci.sh               stages: workflows (formula install)
#   scripts/local-ci.sh install       selected stages only
#   scripts/local-ci.sh --no-signoff  run checks, don't post signoff statuses
#   scripts/local-ci.sh --help        this text
set -euo pipefail

AVAILABLE_STAGES=(workflows install)
DEFAULT_STAGES=(workflows)

_fail()   { printf '✗ %s\n' "$*" >&2; exit 1; }
_log()    { printf '▸ %s\n' "$*"; }
_ok()     { printf '✓ %s\n' "$*"; }
require() { command -v "$1" >/dev/null 2>&1 || _fail "missing '$1'${2:+ — $2}"; }

case "$(uname -s)" in
  Linux) ;;
  *) _fail "Linux-only local CI; refusing to run on $(uname -s) (macOS matrix jobs stay in GitHub Actions)." ;;
esac

NO_SIGNOFF=0
SELECTED=()
while [ $# -gt 0 ]; do
  case "$1" in
    --no-signoff) NO_SIGNOFF=1 ;;
    --list) printf '%s\n' "stages: ${AVAILABLE_STAGES[*]}"; exit 0 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    -*) _fail "unknown option: $1 (try --help)" ;;
    *) SELECTED+=("$1") ;;
  esac
  shift
done
[ ${#SELECTED[@]} -gt 0 ] || SELECTED=("${DEFAULT_STAGES[@]}")

if [ "$NO_SIGNOFF" = 0 ]; then
  require gh ""
  gh extension list 2>/dev/null | grep -qi "gh-signoff" \
    || _fail "gh-signoff extension missing — run: gh extension install basecamp/gh-signoff (or pass --no-signoff)"
fi

# ── stages ────────────────────────────────────────────────────────────────────

run_actionlint() {
  if command -v actionlint >/dev/null 2>&1; then
    actionlint
    return
  fi
  # Same pinned version and checksum as .github/workflows/ci.yml (x86_64 Linux).
  if [ "$(uname -m)" != "x86_64" ]; then
    _fail "actionlint not installed and pinned download needs x86_64 Linux — install actionlint (brew install actionlint)"
  fi
  tmp="${TMPDIR:-/tmp}/actionlint-local-ci"
  mkdir -p "$tmp"
  curl --proto '=https' --tlsv1.2 -LsSf \
    https://github.com/rhysd/actionlint/releases/download/v1.7.12/actionlint_1.7.12_linux_amd64.tar.gz \
    -o "$tmp/actionlint.tar.gz"
  echo "8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8  $tmp/actionlint.tar.gz" | sha256sum --check
  tar -xzf "$tmp/actionlint.tar.gz" -C "$tmp" actionlint
  PATH="$tmp:$PATH" actionlint
}

stage_workflows() {
  require curl ""
  run_actionlint
  require ruby ""
  ruby -c Formula/ts-crap.rb
}

stage_install() {
  # Like the CI install job, against the checked-out formula, on Linux Homebrew.
  require brew "Homebrew on Linux — https://docs.brew.sh/Homebrew-on-Linux"
  export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
  brew install --build-from-source "$PWD/Formula/ts-crap.rb"
  ts-crap --version >/dev/null
  ts-crap --help >/dev/null
}

# ── runner ────────────────────────────────────────────────────────────────────

# Anchor to the repository that owns this script, not the caller's working
# directory — stages and status posting must use this repo's paths and HEAD,
# even when invoked from another checkout, via a symlink, or with CDPATH set
# (cubic P3/P2, CodeRabbit). readlink -f is safe: the runner is Linux-only.
repo_script="$(readlink -f -- "${BASH_SOURCE[0]}")" || _fail "cannot resolve script path"
CDPATH= cd -- "$(dirname -- "$repo_script")/.." \
  || _fail "cannot find repository root"

signoff_failed=0

# Validate all selected stage names before running anything.
for s in "${SELECTED[@]}"; do
  declare -F "stage_$s" >/dev/null || _fail "unknown stage '$s' (stages: ${AVAILABLE_STAGES[*]})"
done

if [ -n "$(git status --porcelain --untracked-files=normal)" ]; then
  # gh-signoff refuses to attest a dirty tree, so fail fast BEFORE the long
  # stages instead of finishing a full run with nothing posted.
  if [ "$NO_SIGNOFF" = 0 ]; then
    _fail "working tree has uncommitted changes — commit or stash them, or pass --no-signoff"
  fi
  _log "warning: working tree has uncommitted changes — results may not match HEAD"
fi

for s in "${SELECTED[@]}"; do
  _log "stage: $s"
  # Bind every status to the exact commit the stage tests (CodeRabbit Major):
  # a commit/push landing mid-stage can no longer be green-lit by mistake.
  head_sha="$(git rev-parse HEAD)"
  # Run the stage in a subshell with errexit, OUTSIDE any if-condition context:
  # inside `if ! (...)` bash suppresses errexit, so a failing command mid-stage
  # could be masked and the stage wrongly reported green (bot review P0).
  set +e
  ( set -e; "stage_$s" )
  rc=$?
  set -e
  if [ "$rc" -ne 0 ]; then
    [ "$NO_SIGNOFF" = 0 ] && gh signoff fail --commit "$head_sha" "$s" --description "$s failed locally" >/dev/null 2>&1 || true
    _fail "stage '$s' failed"
  fi
  # A concurrent commit or uncommitted edit during the stage changes what was
  # tested while $head_sha stays — refuse to attest anything then (cubic P2/P1).
  # Scoped to signed-off runs: dirty trees are allowed with --no-signoff.
  if [ "$(git rev-parse HEAD)" != "$head_sha" ] \
     || { [ "$NO_SIGNOFF" = 0 ] && [ -n "$(git status --porcelain --untracked-files=normal)" ]; }; then
    [ "$NO_SIGNOFF" = 0 ] && gh signoff fail --commit "$head_sha" "$s" --description "$s ran while HEAD moved or tree changed" >/dev/null 2>&1 || true
    _fail "HEAD moved or working tree changed during stage '$s' — aborting instead of attesting untested code"
  fi
  _ok "$s passed"
  if [ "$NO_SIGNOFF" = 0 ]; then
    gh signoff --commit "$head_sha" "$s" >/dev/null 2>&1 \
      || { printf '⚠ could not post signoff status for %s — is HEAD pushed? gh authorized?\n' "$s" >&2; signoff_failed=1; }
  fi
done

# A missing required status is as bad as a failing stage (CodeRabbit Minor).
if [ "$signoff_failed" -ne 0 ]; then
  _fail "one or more signoff statuses could not be posted"
fi

if [ "$NO_SIGNOFF" = 1 ]; then
  _log "all done — no signoff statuses posted (was --no-signoff)."
else
  _log "all done."
fi
