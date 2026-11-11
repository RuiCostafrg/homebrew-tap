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

## dotnet-crap

A quality gate for C# callable CRAP scores. Installs a precompiled binary; Rust
and the .NET SDK are not needed to scan.

```sh
brew install RuiCostafrg/tap/dotnet-crap
dotnet-crap --help
```

Supports macOS (Apple Silicon and Intel) and Linux (ARM64 and x86-64 glibc builds).
The formula is added by the first verified sync after dotnet-crap's first stable
release; it is synced the same way as ts-crap below.
[Source, usage, and releases](https://github.com/RuiCostafrg/dotnet-crap).

## Updates
This tap checks hourly (or on manual dispatch) for a newer stable release.
It verifies GitHub provenance against the exact source workflow, tag, and commit,
then requires RuiCostafrg approval in the protected `homebrew` environment to
open an update PR. Read-only CI tests the proposed formula on macOS and Linux;
RuiCostafrg merges it after checks pass.
Updates use this repository’s short-lived GitHub token; no deploy key or personal
access token is stored. An already-open release update is a successful no-op on subsequent syncs;
new updates must have attestations. SHA-256 hashes in the formula verify the downloaded archives.
