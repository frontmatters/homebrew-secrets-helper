class SecretsHelper < Formula
  desc "macOS keychain manager that replaces .env files, with AI agent skill bundle"
  homepage "https://github.com/frontmatters/secrets-helper"
  url "https://github.com/frontmatters/secrets-helper/archive/refs/tags/v0.2.1.tar.gz"
  version "0.2.1"
  sha256 "98c9745b5fcc6453a91dfb19f1bcd048d904eea0108e350a59dcf844f94baa52"
  license "MIT"

  depends_on :macos

  def install
    # The CLI binary is `secrets` (the `keybuddy` alias was removed in v0.2.0).
    bin.install "bin/secrets"

    # The sourceable bash function wrapper.
    libexec.install "lib/secrets-helper.sh"

    # Bundle the setup wizard, agent-skill content, and VERSION so users can run
    # `secrets-helper-setup` (defined below) and reach the agent skill files.
    # NOTE: install.sh is intentionally NOT bundled. setup.sh runs install.sh only
    # when it sits beside it; omitting it makes the wizard skip the ~/.local/bin
    # symlink step, which Homebrew already provides on PATH.
    libexec.install "setup.sh"
    libexec.install "VERSION"
    libexec.install "agent-skill"
    libexec.install "config.example.sh"

    # Setup wizard wrapper (SCRIPT_DIR resolves to libexec so VERSION/agent-skill
    # are found, and the install.sh guard is skipped).
    (bin/"secrets-helper-setup").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/setup.sh" "$@"
    EOS
    (bin/"secrets-helper-setup").chmod 0755

    # Documentation.
    doc.install "README.md"
    doc.install "CHANGELOG.md"
  end

  def caveats
    <<~EOS
      To finish installation, run the setup wizard:
        secrets-helper-setup

      To use the sourceable bash functions (get, add, list, ...) in your shell,
      add this to your ~/.zshrc or ~/.bashrc:
        source #{libexec}/secrets-helper.sh

      Set SECRETS_HELPER_QUIET=1 to suppress the load banner.
    EOS
  end

  test do
    assert_match "secrets-helper #{version}", shell_output("#{bin}/secrets --version")
  end
end
