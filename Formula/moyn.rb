class Moyn < Formula
  desc "Developer microblogging from your terminal"
  homepage "https://moyn.dev"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.2/moyn-aarch64-apple-darwin.tar.xz"
      sha256 "ed0a985ef62d6d560f8e451f66d91761c221d591ec09b722fa70a96da77155e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.2/moyn-x86_64-apple-darwin.tar.xz"
      sha256 "1f71bba6efd476e55ab242dd53283bd11da91ebbde92a2e4d6536cc2192328b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.2/moyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dba279463598b82d4504f53c3e064dc177e4f1a3c06a5529fecc3bf31fa9adc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.2/moyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e758c83db3328478cdfe0f5a400bc3d466bde4b2d229e0021b7c709f5ed7c692"
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
