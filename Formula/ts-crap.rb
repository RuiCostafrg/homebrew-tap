class TsCrap < Formula
  desc "Source-aware CRAP scores for TypeScript functions"
  homepage "https://github.com/RuiCostafrg/typescript-crap"
  version "2.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.3.2/ts-crap-aarch64-apple-darwin.tar.xz"
      sha256 "5bac9b122f2d3aa9a92de35b56e186742eeec86ef68959bb95e35d9173cb56de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.3.2/ts-crap-x86_64-apple-darwin.tar.xz"
      sha256 "e6d29f4b5ab3ce33999ab4ceb3d39681592ca04044130ad5cf7bcf2389fbdf82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.3.2/ts-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40ec15edd683f80caece7f29e70e6fcf088c7de0a1f75efcaabd9cba62eb674d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/typescript-crap/releases/download/v2.3.2/ts-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ae92f9be6e7c0be01f8359e3fa8256b6bb15d008b340c2940c0347fca308236"
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
