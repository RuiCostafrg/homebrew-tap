class TsCrap < Formula
  desc "Source-aware CRAP scores for TypeScript functions"
  homepage "https://github.com/RuiCostafrg/typescript-crap"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v3.0.0/ts-crap-aarch64-apple-darwin.tar.xz"
      sha256 "0e28a83c8ba6d36c85d96b0dda80eace6809dae304c7715ecb5a99abca420739"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v3.0.0/ts-crap-x86_64-apple-darwin.tar.xz"
      sha256 "1b6a7f845321384fc1901c23f62dc945734b6cbdee989da899b0ae8dd5134973"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v3.0.0/ts-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93ef9c8948362af952b0703c3c6506ec820cf17059f43f95fea921d86fdf16c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v3.0.0/ts-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2c07939eb22d1b18606e8e2face104ac5ea243e27373750ba405af667d6fb53"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ts-crap"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ts-crap"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ts-crap"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ts-crap"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
