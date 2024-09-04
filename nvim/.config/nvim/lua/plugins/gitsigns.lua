return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>gn", function()
          if vim.wo.diff then
            vim.cmd.normal({ "<leader>gn", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "[G]it [N]ext change" })

        map("n", "<leader>gp", function()
          if vim.wo.diff then
            vim.cmd.normal({ "<leader>gp", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "[G]it [P]revious change" })

        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "[G]it [R]eset hunk" })

        map("n", "<leader>gR", gitsigns.reset_buffer, {
          desc = "[G]it [R]eset buffer",
        })

        map("n", "<leader>gb", gitsigns.toggle_current_line_blame, {
          desc = "[G]it [B]lame",
        })
      end,
    })
  end,
}
