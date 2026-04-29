class Keybuddy < Formula
  desc "macOS keychain manager that replaces .env files, with AI agent skill bundle"
  homepage "https://github.com/frontmatters/keybuddy"
  url "https://github.com/frontmatters/keybuddy/archive/refs/tags/v0.1.1.tar.gz"
  # Run `shasum -a 256 v0.1.0.tar.gz` after creating the GitHub release
  # and replace the placeholder below.
  sha256 "54d3115ebf4e9bd74c8c9d5185c9318607b06984c9798b2e8de82c7bb48391fa"
  license "MIT"
  version "0.1.1"

  depends_on :macos

  def install
    # Install the CLI under both names so users can invoke `secrets` or `keybuddy`.
    bin.install "bin/secrets"
    bin.install_symlink "secrets" => "keybuddy"

    # The sourceable bash function wrapper.
    libexec.install "lib/keybuddy.sh"

    # Bundle the setup wizard, agent-skill content, and VERSION so users can
    # run `keybuddy-setup` (defined below) and reach the agent skill files.
    libexec.install "setup.sh"
    libexec.install "VERSION"
    libexec.install "agent-skill"
    libexec.install "config.example.sh"

    # Setup wizard wrapper (puts the SCRIPT_DIR at libexec so VERSION resolves).
    (bin/"keybuddy-setup").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/setup.sh" "$@"
    EOS
    (bin/"keybuddy-setup").chmod 0755

    # Documentation.
    doc.install "README.md"
    doc.install "CHANGELOG.md"
  end

  def caveats
    <<~EOS
      To finish installation, run the setup wizard:
        keybuddy-setup

      To use the sourceable bash functions (get, add, list, ...) in your shell,
      add this to your ~/.zshrc or ~/.bashrc:
        source #{libexec}/keybuddy.sh

      Set KEYBUDDY_QUIET=1 to suppress the load banner.
    EOS
  end

  test do
    assert_match "keybuddy 0.1.1", shell_output("#{bin}/secrets --version")
    assert_match "keybuddy 0.1.1", shell_output("#{bin}/keybuddy --version")
  end
end
