class DotnetCrap < Formula
  desc "C# callable complexity and source-bound CRAP quality gates"
  homepage "https://github.com/RuiCostafrg/dotnet-crap"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v1.0.0/dotnet-crap-aarch64-apple-darwin.tar.xz"
      sha256 "690dda01106cd7319e18dc440b788feb8d323918435506bb70a520b09a21faf1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v1.0.0/dotnet-crap-x86_64-apple-darwin.tar.xz"
      sha256 "7a606dd7b96a885b516c16bf1d78c97145c1475a9bfb1c68d51c5f149018c1dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v1.0.0/dotnet-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc2c0ccaaa06fd5461f71771a6bbaff047ec408a7444c8925334f3077e85b6f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v1.0.0/dotnet-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edeb017d3fcc28343e6671b239fcded496c1d3aff0d8caeecede450981044cbf"
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
