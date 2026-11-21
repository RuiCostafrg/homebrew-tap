class DotnetCrap < Formula
  desc "C# callable complexity and source-bound CRAP quality gates"
  homepage "https://github.com/RuiCostafrg/dotnet-crap"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.2/dotnet-crap-aarch64-apple-darwin.tar.xz"
      sha256 "817b23f13cde0c4932cfc28ff486c35c957600bbbc3dc200ab3072909bc744b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.2/dotnet-crap-x86_64-apple-darwin.tar.xz"
      sha256 "e2c1c560d869bded8c4309a8638f33219a0862e0735293656f59f7dc4ad868c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.2/dotnet-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0aae2f0e5669efa99fb8c9e4774e575e50cde44c539429496d7f707e1fdddf0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.2/dotnet-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1429db670d122de6298f6d8f052f4ec56ba506b1134deece83c33697d3b546b1"
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
      bin.install "dotnet-crap"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dotnet-crap"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dotnet-crap"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dotnet-crap"
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
