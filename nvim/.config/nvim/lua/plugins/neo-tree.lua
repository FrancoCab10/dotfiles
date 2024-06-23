return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    require("neo-tree").setup({
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        width = 30,
      },
      default_component_configs = {
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "󱇬",
            modified = "󰙏",
            deleted = "󰗨",
            renamed = "󰜴",
            -- Status type
            untracked = "󰡯",
            ignored = "󰷆",
            unstaged = "󰩍",
            staged = "󱀺",
            conflict = "󰱾",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
    })

    vim.keymap.set("n", "<C-b>", ":Neotree filesystem toggle left<CR>")
    vim.keymap.set("n", "<C-e>", ":Neotree focus<CR>")
  end,
}
