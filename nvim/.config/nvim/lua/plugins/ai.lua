return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				default = "copilot",
			},
			clients = {
				copilot = {
					install = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>"
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion and ",
			},
			{
				"<C-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select({ filter = { installed = true } })
				end,
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "copilot", focus = true })
				end,
				desc = "Sidekick Toggle Chat",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
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
			end, { desc = "AI Toggle in-line suggestions" })

			vim.keymap.set("i", "<CR>", function()
				if sug.is_visible() then
					return sug.accept()
				else
					return "\n"
				end
			end, { expr = true, desc = "AI Accept in-line suggestion" })

			vim.keymap.set("i", "<ESC>", function()
				if sug.is_visible() then
					return sug.dismiss()
				else
					return "<ESC>"
				end
			end, { expr = true, desc = "AI Dismiss in-line suggestion" })
		end,
	},
}
