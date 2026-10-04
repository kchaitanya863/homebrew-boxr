class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "MIT"
  head "https://github.com/kchaitanya863/boxr.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.52/boxr-macos-arm64.tar.gz"
      sha256 "340dd1ab395f7ca16fce40d0d0257329b4c589ae2d99b2e0c89b64913f26739b"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.52/boxr-macos-x86_64.tar.gz"
      sha256 "5d3d613c840442cb043c4c5595f7ca12790e9b03212e702fdc87a7d1a31f962f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.52/boxr-linux-arm64.tar.gz"
      sha256 "fbda9a112c828d2a40df240595de0fbf6ad4702cb0b24934255a2370cfb4b2eb"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.52/boxr-linux-x86_64.tar.gz"
      sha256 "090c687215a9a62ca41e53dd4740ebfec9861cf4f86bbf88636b9a04adf38c09"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "bin/boxr"
    end

    # Shell completions
    bash_completion.install "completions/boxr.bash" => "boxr" if File.exist?("completions/boxr.bash")
    zsh_completion.install "completions/_boxr" => "_boxr" if File.exist?("completions/_boxr")
    fish_completion.install "completions/boxr.fish" => "boxr.fish" if File.exist?("completions/boxr.fish")
  end

  service do
    run [opt_bin/"boxr", "daemon"]
    keep_alive true
    log_path var/"log/boxr.log"
    error_log_path var/"log/boxr.log"
    working_dir var
  end

  def caveats
    <<~EOS
      (Optional) Docker Drop-in Alias:
      If you want 'docker' commands to transparently invoke boxr:
        boxr alias --install
      or add to your shell profile (~/.zshrc or ~/.bashrc):
        alias docker="boxr"
    EOS
  end

  test do
    assert_match "boxr", shell_output("#{bin}/boxr --version")
    assert_match "Containers:", shell_output("#{bin}/boxr info")
  end
end
