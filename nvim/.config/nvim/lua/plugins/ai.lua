return {
	-- GitHub Copilot (inline suggestions)
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-y>",
					dismiss = "<C-d>",
				},
			},
			panel = { enabled = false },
			filetypes = { ["*"] = true },
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			-- Auth
			vim.keymap.set("n", "<leader>aa", "<cmd>Copilot auth<CR>", { desc = "AI Auth" })

			-- Toggle Suggestions
			local sug = require("copilot.suggestion")
			vim.keymap.set({ "n", "i" }, "<leader>at", function()
				if sug.is_enabled() then
					sug.disable()
					if vim.fn.mode():match("[iR]") then
						sug.dismiss()
					end
					vim.notify("Copilot suggestions: OFF")
				else
					sug.enable()
					vim.notify("Copilot suggestions: ON")
				end
			end, { desc = "AI Toggle Suggestions" })
		end,
	},

	-- Copilot Chat (vertical split + model picker)
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
		},
		lazy = false,
		opts = {
			window = {
				layout = "vertical",
			  width = 0.35,
			},
			headers = {
				user = "",
				assistant = "",
				tool = "",
			},
      chat_autocomplete = false,
			model = "gpt-4.1", -- Change with :CopilotChatModels
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)

			-- Chat
			vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChat<CR>", { desc = "AI Chat" })
			vim.keymap.set("v", "<leader>ac", ":CopilotChat<CR>", { desc = "AI Chat (Selection)" })

			-- Select Model
			vim.keymap.set("n", "<leader>am", "<cmd>CopilotChatModels<CR>", { desc = "AI Select Model" })

			-- Custom settings for chat window
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function(ctx)
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
					vim.opt_local.signcolumn = "no"
					vim.opt_local.foldcolumn = "0"
					vim.opt_local.cursorline = false
					vim.opt_local.statuscolumn = ""
					vim.opt_local.wrap = true
					vim.opt_local.breakindent = true
				end,
			})
		end,
	},
}
