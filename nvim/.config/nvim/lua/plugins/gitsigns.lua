return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "▁" },
      topdelete    = { text = "▔" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    signcolumn = true,
    attach_to_untracked = true,
    watch_gitdir = { interval = 1000, follow_files = true },
    current_line_blame = false,
  },
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)

    -- keymaps
    local map = vim.keymap.set
    map("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Previous hunk" })
    map("n", "<leader>gn", gitsigns.next_hunk, { desc = "Next hunk" })
    map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
    map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>gP", gitsigns.preview_hunk, { desc = "Preview hunk" })
  end,
}
