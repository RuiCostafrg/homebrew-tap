class TsCrap < Formula
  desc "Source-aware CRAP scores for TypeScript functions"
  homepage "https://github.com/RuiCostafrg/typescript-crap"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v1.0.0/ts-crap-aarch64-apple-darwin.tar.xz"
      sha256 "73a93e5741abad41f0178cfbbf071c31ba3f1cf96ab412c0c2943e692dfa5186"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v1.0.0/ts-crap-x86_64-apple-darwin.tar.xz"
      sha256 "6f56683ad44f11ceab089df40770a7c33f79355e8ad26421932c16963be6ad90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v1.0.0/ts-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a9aa4b25155f754af2abc47951ebb229f777c91c6fa62f96346a90c4affafd01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v1.0.0/ts-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c195efbc9185e1fd3eb412afae26400efa9f4725376a47c481c3087b7df1edc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
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
