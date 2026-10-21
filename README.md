# Homebrew tap

Prebuilt command-line tools maintained by [RuiCostafrg](https://github.com/RuiCostafrg).

## ts-crap

A quality gate for TypeScript function CRAP scores. Installs a precompiled binary;
Rust, a C compiler, and Node.js are not needed to run the analyzer.

```sh
brew install RuiCostafrg/tap/ts-crap
ts-crap --help
```

Supports macOS (Apple Silicon and Intel) and Linux (ARM64 and x86-64, glibc 2.35+).
To update:

```sh
brew update
brew upgrade ts-crap
```

[Source, usage, and releases](https://github.com/RuiCostafrg/typescript-crap).
This tap checks hourly (or on manual dispatch) for a newer stable release.
It verifies GitHub provenance against the exact source workflow, tag, and commit,
then requires RuiCostafrg approval in the protected `homebrew` environment.
Updates use this repository’s short-lived GitHub token; no deploy key or personal
access token is stored. The existing v0.1.0 formula is retained; new updates must
have attestations. SHA-256 hashes in the formula verify the downloaded archives.
