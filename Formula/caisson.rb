class Caisson < Formula
  desc "Daemon-shielded sibling APFS workspaces and CoW git worktrees for macOS"
  homepage "https://github.com/beckhq/caisson"
  url "https://github.com/beckhq/caisson/releases/download/v0.1.5/caisson-v0.1.5-universal-apple-darwin.tar.gz"
  sha256 "010dd217a38f5912814859a6217788a85c5165f5d7014fa89cc0f5a9fd8863c7"
  license "MIT"

  depends_on :macos

  def install
    bin.install "caisson"
    generate_completions_from_executable(bin/"caisson", "completions")
  end

  def caveats
    <<~EOS
      Run one-time APFS workspace setup (zero sudo needed afterward for worktrees):
        caisson doctor
        sudo caisson init
        sudo caisson daemon install

      Wire up your coding agents (Claude Code, Codex, Antigravity, Cursor, OpenCode, Windsurf):
        caisson agent install

      Enable `caisson wt cd <slug>` in your shell (~/.zshrc):
        eval "$(caisson shell-init zsh --alias cai)"
    EOS
  end

  test do
    assert_match "caisson #{version}", shell_output("#{bin}/caisson --version")
    (testpath/"src.txt").write("hello apfs")
    system bin/"caisson", "clone", testpath/"src.txt", testpath/"dst.txt"
    assert_equal "hello apfs", (testpath/"dst.txt").read
  end
end
