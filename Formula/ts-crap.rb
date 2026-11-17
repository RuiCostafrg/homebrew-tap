class TsCrap < Formula
  desc "Source-aware CRAP scores for TypeScript functions"
  homepage "https://github.com/RuiCostafrg/typescript-crap"
  version "2.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.5.0/ts-crap-aarch64-apple-darwin.tar.xz"
      sha256 "9d5cc49dee60330aadf344b6b4711c03c3a948550f43c6f49e626d8f138c1a13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.5.0/ts-crap-x86_64-apple-darwin.tar.xz"
      sha256 "2cc02c90d62d2789663a1a7d2b678b74ce9feae6bfd92c8b0c282e740a529883"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.5.0/ts-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "35b36bcae58a820eafaeac83f9d9d73a84f18286b2692e9e6fb5ed105c8e0cd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.5.0/ts-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5aa3325ca8afd170c9c30f799125a88f57617d9d0b1fa242082956f99b3246eb"
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
