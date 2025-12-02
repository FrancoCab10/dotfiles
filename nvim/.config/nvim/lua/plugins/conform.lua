return {
	"stevearc/conform.nvim",
	event = "BufReadPre",
	opts = function()
		-- known formatter configs
		local formatter_configs = {
			biome = {
				files = { "biome.json", "biome.jsonc" },
				bins = { "node_modules/.bin/biome" },
			},
			eslint = {
				files = {
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.cjs",
					"eslint.config.mjs",
					"eslint.config.ts",
				},
				bins = { "node_modules/.bin/eslint", "node_modules/.bin/eslint_d" },
			},
			prettier = {
				files = {
					".prettierrc",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.json",
					".prettierrc.toml",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"prettier.config.ts",
				},
				bins = { "node_modules/.bin/prettierd", "node_modules/.bin/prettier" },
			},
		}

		-- project detection
		local function project_uses(dir, name)
			local cfg = formatter_configs[name]
			if not cfg then
				return false
			end
			local found_file = vim.fs.find(cfg.files or {}, { path = dir, upward = true })[1]
			local found_bin = vim.fs.find(cfg.bins or {}, { path = dir, upward = true })[1]
			return found_file ~= nil or found_bin ~= nil
		end

		return {
			formatters_by_ft = {
				javascript = { "biome", "eslint_d", "prettierd", "prettier" },
				javascriptreact = { "biome", "eslint_d", "prettierd", "prettier" },
				typescript = { "biome", "eslint_d", "prettierd", "prettier" },
				typescriptreact = { "biome", "eslint_d", "prettierd", "prettier" },
				vue = { "biome", "eslint_d", "prettierd", "prettier" },
				lua = { "stylua" },
			},
			formatters = {
				biome = {
					condition = function(ctx)
						return project_uses(ctx.dirname, "biome")
					end,
				},
				eslint_d = {
					condition = function(ctx)
						if project_uses(ctx.dirname, "biome") then
							return false
						end
						return project_uses(ctx.dirname, "eslint")
					end,
				},
				prettierd = {
					condition = function(ctx)
						if project_uses(ctx.dirname, "biome") then
							return false
						end
						return project_uses(ctx.dirname, "prettier")
					end,
				},
				prettier = {
					condition = function(ctx)
						if project_uses(ctx.dirname, "biome") then
							return false
						end
						return project_uses(ctx.dirname, "prettier")
					end,
				},
			},
			--[[ form at_on_save = function(bufnr)
		    local js_like = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
        local ft = vim.bo[bufnr].filetype
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
        local is_js_like = vim.tbl_contains(js_like, ft)

        if is_js_like then
          local has_any_tool = project_uses(dir, "biome")
            or project_uses(dir, "eslint")
            or project_uses(dir, "prettier")
          return {
            timeout_ms = 500,
            lsp_fallback = not has_any_tool,
          }
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end, ]]
			notify_on_error = true,
		}
	end,
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)
		vim.api.nvim_create_user_command("Format", function()
			conform.format({ async = true })
		end, {})

		-- bind to <leader>cf
		vim.keymap.set("n", "<leader>cf", function()
			conform.format({ async = true })
		end, {
			desc = "Conform format",
			noremap = true,
			silent = true,
		})
	end,
}
