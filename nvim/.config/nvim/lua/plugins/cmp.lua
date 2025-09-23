return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
	},
	event = "InsertEnter",
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		vim.opt.pumheight = 12

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),

				["<Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end,

				["<C-n>"] = function(fallback)
					if luasnip.jumpable(1) then
						luasnip.jump(1)
					elseif cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end,

				["<C-p>"] = function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					elseif cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end,
			}),

			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "copilot", group_index = 2 },
				{ name = "path" },
				{ name = "buffer" },
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local MAX = 40
					item.abbr = item.abbr:gsub("%s+", " ")
					if #item.abbr > MAX then
						item.abbr = item.abbr:sub(1, MAX) .. "…"
					end

					-- use mini.icons if available
					local ok, icons = pcall(require, "mini.icons")
					if ok then
						local icon, hl = icons.get("lsp", item.kind)
						if icon then
							item.kind = icon
							item.kind_hl_group = hl
						end
					else
						-- fallback if mini.icons isn’t available
						local fallback = {
							Text = "",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰇽",
							Variable = "󰂡",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "󰊄",
						}
						item.kind = fallback[item.kind] or ""
					end

					item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
						copilot = "[AI]",
					})[entry.source.name] or ""

					return item
				end,
			},

			completion = { completeopt = "menu,menuone,noinsert" },
			experimental = { ghost_text = false },
			preselect = cmp.PreselectMode.None,
		})
	end,
}
