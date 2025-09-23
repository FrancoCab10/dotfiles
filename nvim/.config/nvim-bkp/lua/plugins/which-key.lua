return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup()

    -- Document existing key chains
    wk.add({
      { "<leader>c",  group = "[C]ode" },
      { "<leader>d",  group = "[D]iagnostics" },
      { "<leader>g",  group = "[G]it" },
      { "<leader>r",  group = "[R]ename" },
      { "<leader>s",  group = "[S]earch" },
      { "<leader>t",  group = "[T]oggle" },
      { "<leader>w",  group = "[W]orkspace" },
      -- visual mode
      { "<leader>g", group = "[G]it", mode = "v" },
      { "<leader>t", group = "[T]oggle", mode = "v" },
    })
  end,
}
