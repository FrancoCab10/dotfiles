return {
  -- INFO: NEOCONF
  {
    "folke/neoconf.nvim",
    config = function()
      require("neoconf").setup({})
    end,
  },
  -- INFO: LSP
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "volar",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local vue_language_server_path = require("mason-registry").get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"

      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "typescript", "javascript", "vue" },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      lspconfig.volar.setup({ capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "[T]oggle Inlay [H]ints")
          end

          -- Diagnostics

          local function refresh_diagnostics_screen()
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { " " })
            vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
            vim.diagnostic.show()
          end

          local function toggle_diagnostics_mode()
            vim.g.diagnostics_show_text = not vim.g.diagnostics_show_text

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
              vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = vim.g.diagnostics_show_text,
                signs = true,
                underline = true,
              })

            refresh_diagnostics_screen()
            print("Diagnostics: Virtual Text Show: " .. tostring(vim.g.diagnostics_show_text))
          end

          vim.keymap.set("n", "<leader>dt", toggle_diagnostics_mode, {
            desc = "[D]iagnostic [T]oggle virtual text",
          })
          vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {
            desc = "Go to [P]revious [D]iagnostic message",
          })
          vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {
            desc = "Go to next [D]iagnostic message",
          })
          vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, {
            desc = "Show [D]iagnostic [E]rror messages",
          })
          vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, {
            desc = "Open [D]iagnostic [Q]uickfix list",
          })
        end,
      })
    end,
  },
  -- INFO: FORMATTING & DIAGNOSTICS
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          require("none-ls.diagnostics.eslint"),
          require("none-ls.formatting.eslint"),
          null_ls.builtins.formatting.stylua,
        },
      })

      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat buffer" })
    end,
  },
  -- INFO: AUTOCOMPLETE & SNIPPETS
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
          "rafamadriz/friendly-snippets",
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
}
