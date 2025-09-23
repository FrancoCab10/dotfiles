return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 800,
    icons = {
      mappings = true,
      group = "",
      separator = "➜",
    },
  },
  init = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>a", group = "AI" },
      { "<leader>c", group = "Code" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>j", group = "Leap", icon = { icon = "󱕘", color = "orange" } },
      { "<leader>J", group = "Leap across windows", icon = { icon = "󱕘", color = "orange" } },
      { "<leader>t", group = "Terminal" },
      { "<leader>h", group = "Harpoon", icon = { icon = "󱡅", color = "orange" } },
      { "<leader>w", group = "Windows" },
      { "<leader>r", group = "Replace", icon = { icon = "󰛔", color = "purple" } },
      { "<leader>d", group = "Diagnostics" },
    })
  end,
}
