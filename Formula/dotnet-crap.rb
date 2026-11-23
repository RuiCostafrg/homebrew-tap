class DotnetCrap < Formula
  desc "C# callable complexity and source-bound CRAP quality gates"
  homepage "https://github.com/RuiCostafrg/dotnet-crap"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.3.0/dotnet-crap-aarch64-apple-darwin.tar.xz"
      sha256 "0d09748cb58771758b80255c4cab501162afba339a640e257815c3143f4b2e49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.3.0/dotnet-crap-x86_64-apple-darwin.tar.xz"
      sha256 "98976f63eac4c950e595b2cf15e5f25532fd014fe916ddcd8b6d8ac85d226cb0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.3.0/dotnet-crap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79ab2195b5f14026f429deefe3ce6394a15a850db928eb7201978783d92e5a22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RuiCostafrg/dotnet-crap/releases/download/v0.3.0/dotnet-crap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "61e89c7b9136a255568bccaf13763435d9560c36b2640dcb044d26dcd27df6c2"
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
