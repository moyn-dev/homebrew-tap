class Moyn < Formula
  desc "Developer microblogging from your terminal"
  homepage "https://moyn.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.1/moyn-aarch64-apple-darwin.tar.xz"
      sha256 "dda84eae2d45c92990f3eabfa3a8d6b4663b22c0d6ef01f0daa8d3c0ffcd552f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.1/moyn-x86_64-apple-darwin.tar.xz"
      sha256 "60847983430bef70c1452bc3098731b74c627fcbd8c3ea2477e314a3becf94f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.1/moyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05c8bf8a48fa709c11e0a8cc7d357693d16e7071a857ab6f1455edd485c157aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.1/moyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f29dcb86c75e34a44dbd55a2943810f7e3dbe03adc1a647e7945af3a97aa138"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "moyn" if OS.mac? && Hardware::CPU.arm?
    bin.install "moyn" if OS.mac? && Hardware::CPU.intel?
    bin.install "moyn" if OS.linux? && Hardware::CPU.arm?
    bin.install "moyn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
