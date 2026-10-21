class Forculus < Formula
  desc "Deploy private apps and share them by email, from a terminal or an AI agent"
  homepage "https://forculuslabs.tech"
  version "0.1.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Forculus-Labs/forculus/releases/download/v0.1.14/forculus-aarch64-apple-darwin.tar.xz"
      sha256 "43fce1c16a90f3ff8017d774d2b61f8a8881607b785a68a9924ecec7414b748c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Forculus-Labs/forculus/releases/download/v0.1.14/forculus-x86_64-apple-darwin.tar.xz"
      sha256 "11526e8c35c4ffaf8702a53d7c973b7da8b9a168ff0d38fbf0064b6224cc3b72"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Forculus-Labs/forculus/releases/download/v0.1.14/forculus-aarch64-unknown-linux-musl.tar.xz"
      sha256 "27e62d0de2b22738c14d894a05f4a102e70e3be894618afa1c413dd1b58bb54c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Forculus-Labs/forculus/releases/download/v0.1.14/forculus-x86_64-unknown-linux-musl.tar.xz"
      sha256 "152029773d430a269792b472deb17d1ffbfbd09529036a35eaf358bd8654ed98"
    end
  end
  # The forculus CLI is proprietary, binaries only: https://forculuslabs.tech/terms
  # The SDKs and the agent plugin in Forculus-Labs/forculus are Apache-2.0.
  license "LicenseRef-Proprietary"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-pc-windows-gnu": {},
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
      bin.install "forculus"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "forculus"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "forculus"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "forculus"
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
