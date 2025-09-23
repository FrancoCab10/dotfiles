return {
  "refractalize/oil-git-status.nvim",
  dependencies = { "stevearc/oil.nvim" },
  lazy = false,
  config = function()
    require("oil-git-status").setup({
      show_ignored = true,
    })
  end,
}
