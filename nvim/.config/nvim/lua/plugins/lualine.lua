return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  lazy = false,
  opts = {
    options = {
      theme = "tokyonight",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      icons_enabled = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          function()
            return vim.fn.mode():sub(1, 1):upper()
          end,
          icon = "",
        },
      },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        { "filename", path = 0, symbols = { modified = " ", readonly = " " } },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = {
            error = " ",
            warn  = " ",
            info  = " ",
            hint  = "󰌵 ",
          },
        },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients > 0 then
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return "  " .. table.concat(names, ",")
            end
            return ""
          end,
          icon = "",
        },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  },
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
