# Stage definitions for the shared verified-release-kit runner.
LOCAL_CI_NAME="homebrew-tap"
LOCAL_CI_DESCRIPTION="Mirrors the workflow lint and formula install jobs in .github/workflows/ci.yml."
LOCAL_CI_STAGES=(workflows install)
LOCAL_CI_DEFAULT_STAGES=(workflows)

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
  for formula in Formula/*.rb; do ruby -c "$formula"; done
}

stage_install() {
  require brew "Homebrew on Linux — https://docs.brew.sh/Homebrew-on-Linux"
  export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
  local tap="${LOCAL_CI_BREW_TAP:-RuiCostafrg/tap}" tap_dir formula name
  tap_dir="$(brew --repository "$tap")"
  if [ "$(readlink -f -- "$tap_dir")" != "$PWD" ]; then
    _fail "run the install stage from the Homebrew checkout for $tap: $tap_dir"
  fi
  for formula in Formula/*.rb; do
    name=$(basename "$formula" .rb)
    brew install --formula --build-from-source "$tap/$name"
    "$name" --version >/dev/null
    "$name" --help >/dev/null
  done
}
