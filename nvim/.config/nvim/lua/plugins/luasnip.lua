return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  lazy = false,
  config = function()
    local luasnip = require("luasnip")

    -- load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- expand snippet with <Tab>
    vim.keymap.set("i", "<Tab>", function()
      if luasnip.expandable() then
        return "<Plug>luasnip-expand-snippet"
      else
        return "<Tab>"
      end
    end, { expr = true, silent = true })

    -- jump forward/backward with <C-n>/<C-p>
    vim.keymap.set({ "i", "s" }, "<C-n>", function()
      return luasnip.jumpable(1) and "<Plug>luasnip-jump-next" or "<C-n>"
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<C-p>", function()
      return luasnip.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<C-p>"
    end, { expr = true, silent = true })

    -- reload custom snippets
    vim.keymap.set("n", "<leader>cs", function()
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      print("Snippets reloaded")
    end, { desc = "Reload snippets" })
  end,
  dependencies = { "rafamadriz/friendly-snippets" },
}
