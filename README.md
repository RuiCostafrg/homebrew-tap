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
The release workflow in that repository automatically updates this tap after each
stable release. SHA-256 hashes in the formula verify the downloaded archives.
