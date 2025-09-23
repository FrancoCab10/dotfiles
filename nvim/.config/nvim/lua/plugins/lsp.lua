return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    lazy = false,
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- Use LSPConfig server names
        ensure_installed = { "lua_ls", "vtsls", "vue_ls" },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local function on_attach(_, bufnr)
        local m = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation / info
        m("gd", vim.lsp.buf.definition, "Goto Definition")
        m("gr", vim.lsp.buf.references, "References")
        m("K", vim.lsp.buf.hover, "Hover Docs")

        -- Code group
        m("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
        m("<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format Buffer")
        m("<leader>ca", vim.lsp.buf.code_action, "Code Action")

        -- Diagnostics group
        local vt = true
        local function toggle_vt()
          vt = not vt
          vim.diagnostic.config({ virtual_text = vt })
        end
        m("<leader>dp", vim.diagnostic.goto_prev, "Previous Diagnostic")
        m("<leader>dn", vim.diagnostic.goto_next, "Next Diagnostic")
        m("<leader>di", function()
          vim.diagnostic.open_float({ scope = "cursor", focus = false })
        end, "Current Diagnostic Info")
        m("<leader>dt", toggle_vt, "Toggle Inline Diagnostics")
      end

      -- Resolve locations from Mason (v2 layout)
      local vue_language_server_path = vim.fn.stdpath("data")
          .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      local tsdk = vim.fn.stdpath("data")
          .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"

      -- Vue plugin descriptor injected into vtsls
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      -- TypeScript / JavaScript (vtsls) with the Vue TS plugin and vue in filetypes
      local tsserver_filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "vue",
      }
      local vtsls_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = tsserver_filetypes,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = { vue_plugin },
            },
          },
        },
      }

      -- Vue LS (vue_ls) – forwards TS requests to vtsls so .vue gets proper TS smarts
      local vue_ls_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "vue" },
        init_options = {
          typescript = { tsdk = tsdk },
        },
        on_init = function(client)
          client.handlers["tsserver/request"] = function(_, result, context)
            local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
            if #ts_clients == 0 then
              vim.notify("No vtsls client for vue_ls to forward to.", vim.log.levels.ERROR)
              return
            end
            local ts_client = ts_clients[1]
            local param = table.unpack(result)
            local id, command, payload = table.unpack(param)
            ts_client:exec_cmd({
              title = "vue_request_forward",
              command = "typescript.tsserverRequest",
              arguments = { command, payload },
            }, { bufnr = context.bufnr }, function(_, r)
              local response = r and r.body
              local response_data = { { id, response } }
              client:notify("tsserver/response", response_data)
            end)
          end
        end,
      }

      -- Lua (recognize `vim`, no third-party checks)
      local lua_ls_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- Define with new API
      vim.lsp.config("lua_ls", lua_ls_config)
      vim.lsp.config("vtsls", vtsls_config)
      vim.lsp.config("vue_ls", vue_ls_config)

      -- Start them
      vim.lsp.enable({ "lua_ls", "vtsls", "vue_ls" })
    end,
  },
}
