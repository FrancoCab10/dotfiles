return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  opts = {
    shade_terminals = true,
    start_in_insert = true,
    persist_mode = true,
    direction = "float",
    float_opts = { border = "rounded" },
    size = function(term)
      if term.direction == "horizontal" then return 12 end
      if term.direction == "vertical" then return math.floor(vim.o.columns * 0.38) end
      return 20
    end,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Helpers
    local Terminal = require("toggleterm.terminal").Terminal
    local float = Terminal:new({ direction = "float" })
    local horiz = Terminal:new({ direction = "horizontal" })
    local vert  = Terminal:new({ direction = "vertical" })

    -- Keymaps (normal mode)
    vim.keymap.set("n", "<leader>tf", function() float:toggle() end, { desc = "Terminal (float)" })
    vim.keymap.set("n", "<leader>th", function() horiz:toggle() end, { desc = "Terminal (horizontal)" })
    vim.keymap.set("n", "<leader>tv", function() vert:toggle() end,  { desc = "Terminal (vertical)" })

    -- Terminal-mode quality of life
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        -- Esc to normal, and window nav with Ctrl-h/j/k/l from terminal
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true, silent = true })
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { buffer = true, silent = true })
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { buffer = true, silent = true })
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { buffer = true, silent = true })
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { buffer = true, silent = true })
      end,
    })
  end,
}

