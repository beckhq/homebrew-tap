class Caisson < Formula
  desc "Daemon-shielded sibling APFS workspaces and CoW git worktrees for macOS"
  homepage "https://github.com/beckhq/caisson"
  url "https://github.com/beckhq/caisson/releases/download/v0.1.3/caisson-v0.1.3-universal-apple-darwin.tar.gz"
  sha256 "fa6f963dea2fa3d4846083f9303899e74a48b988541044f7981cdec0896ad59e"
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
