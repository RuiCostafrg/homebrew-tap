class DotnetCrap < Formula
  desc "C# callable complexity and source-bound CRAP quality gates"
  homepage "https://github.com/RuiCostafrg/dotnet-crap"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.1/dotnet-crap-aarch64-apple-darwin.tar.xz"
      sha256 "0bb264bdd71e5935c867448c3e39a16e1be1c2eac7079d28bb2e17546eab6bbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.1/dotnet-crap-x86_64-apple-darwin.tar.xz"
      sha256 "70b2e6455e2c7d1e4850cbdfbcab232075f3b55e506d69a80baa7bca2664eb80"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.1/dotnet-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e8910a8fbd89d9252033f8ee80f1f7600e51d7816ceba9b4c4d907bad106505"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.2.1/dotnet-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36094b1692070d3665127a9b4eb05b62dd80a392485161e3f354283b8bee1f97"
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
