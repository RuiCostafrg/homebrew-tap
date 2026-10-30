class TsCrap < Formula
  desc "Source-aware CRAP scores for TypeScript functions"
  homepage "https://github.com/RuiCostafrg/typescript-crap"
  version "2.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.2.1/ts-crap-aarch64-apple-darwin.tar.xz"
      sha256 "771f4dcecc34b6358f084f020b72dcb69668ececfe497521ecad2c775803f3f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.2.1/ts-crap-x86_64-apple-darwin.tar.xz"
      sha256 "eca4575c0df7a30536412a49572aef69bb2889c1efdca6d42a2e3c0fac4fb36a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.2.1/ts-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3bf8bdfb75ba0b24a5825342ce0245dadb6c7c5f64d0dc6f35792497fcbe6143"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.2.1/ts-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d605d0213cf173461d4565a86181e8d738d53a5dbce2b4f45a6647353adea4ad"
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
