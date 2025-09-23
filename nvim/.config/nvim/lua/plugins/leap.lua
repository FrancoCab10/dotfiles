return {
  "ggandor/leap.nvim",
  config = function()
    vim.keymap.set("n", "<leader>j", "<Plug>(leap)")
    vim.keymap.set("n", "<leader>J", "<Plug>(leap-from-window)")
    vim.keymap.set({ "x", "o" }, "<leader>j", "<Plug>(leap-forward)")
    vim.keymap.set({ "x", "o" }, "<leader>J", "<Plug>(leap-backward)")
  end,
}
