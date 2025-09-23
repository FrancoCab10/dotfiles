return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    signs = true,
    keywords = {
      FIX  = { icon = "", color = "error",  alt = { "FIXME", "BUG" } },
      TODO = { icon = "", color = "info" },
      HACK = { icon = "", color = "warning" },
      WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = "", color = "hint",   alt = { "OPTIM", "PERFORMANCE" } },
      NOTE = { icon = "", color = "hint",   alt = { "INFO" } },
    },
    highlight = {
      multiline = false,
      before = "",
      keyword = "wide",
      after = "fg",
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg" },
      warning = { "DiagnosticWarn" },
      info = { "DiagnosticInfo" },
      hint = { "DiagnosticHint" },
      default = { "Identifier" },
    },
    search = {
      command = "rg",
      args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
    },
  },
  config = function(_, opts)
    require("todo-comments").setup(opts)
    local todo = require("todo-comments")
    vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next TODO" })
    vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Prev TODO" })
    vim.keymap.set("n", "<leader>ft", "<CMD>TodoTelescope<CR>", { desc = "Find TODOs" })
  end,
}
