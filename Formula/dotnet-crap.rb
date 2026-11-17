class DotnetCrap < Formula
  desc "C# callable complexity and source-bound CRAP quality gates"
  homepage "https://github.com/RuiCostafrg/dotnet-crap"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.1.0/dotnet-crap-aarch64-apple-darwin.tar.xz"
      sha256 "7d3cd1fc89b161a43c983db58d66a67432458ecefa51f9391c9bfeaa9a13038d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.1.0/dotnet-crap-x86_64-apple-darwin.tar.xz"
      sha256 "fdf892b0cf0518b3276275fc6b4b74381ca3b979c56e47466f5facb1562ba22d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.1.0/dotnet-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a7eb80a78106712b0430bdac1bdc8053f09c7dcfc14debc50c2d68a6bf58369"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.1.0/dotnet-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f4815c1aa888e7e3ecf9f8e43a7f51a32b61155844f05f287a93b6a21471ec7"
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
