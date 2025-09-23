return {
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = {
        line = "<leader>tc",
        block = "<leader>tC",
      },
      opleader = {
        line = "<leader>tc",
        block = "<leader>tC",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
