class Moyn < Formula
  desc "Developer microblogging from your terminal"
  homepage "https://moyn.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.0/moyn-aarch64-apple-darwin.tar.xz"
      sha256 "b6b5f23f68ad9df1e3b451e6aca697859151e6ff7c0080a87ebe5b612c899919"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.0/moyn-x86_64-apple-darwin.tar.xz"
      sha256 "01224f32fb6eee9695f6fcc90fe23964b3059d09b115db32694a5d77e75f403f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.0/moyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84cfdbf72ceb955b31fc60f055fd0c9071e85ec0e2dd61eb3307fff4d9228b26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/moyn-dev/moyn-cli/releases/download/v0.1.0/moyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5570bad748691f84544c3230ca0a77b3169370f9c5e6d54c8170128cb045dca"
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
