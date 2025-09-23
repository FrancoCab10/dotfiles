return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    local api = require("Comment.api")

    -- line comments
    vim.keymap.set("n", "<leader>cl", api.toggle.linewise.current, { desc = "Toggle line comment" })
    vim.keymap.set("v", "<leader>cl", function()
      api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle line comment (visual)" })

    -- block comments
    vim.keymap.set("n", "<leader>cb", api.toggle.blockwise.current, { desc = "Toggle block comment" })
    vim.keymap.set("v", "<leader>cb", function()
      api.toggle.blockwise(vim.fn.visualmode())
    end, { desc = "Toggle block comment (visual)" })
  end,
}
