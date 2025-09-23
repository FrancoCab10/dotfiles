return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit (cwd)" },
    { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "Lazygit (file root)" },
  },
}

