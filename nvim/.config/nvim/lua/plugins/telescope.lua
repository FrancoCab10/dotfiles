return {
	"nvim-telescope/telescope.nvim",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ahmedkhalf/project.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	keys = (function()
		require("telescope").load_extension("projects")
		local b = function(name)
			return function()
				return require("telescope.builtin")[name]()
			end
		end
		local grep_cword = function()
			require("telescope.builtin").grep_string({ word_match = "-w" })
		end
		return {
			{ "<leader>ff", b("find_files"), desc = "Find files" },
			{ "<leader>fp", ":Telescope projects<CR>", desc = "Projects" },
			{ "<leader>fg", b("live_grep"), desc = "Live grep" },
			{ "<leader>fw", grep_cword, desc = "Grep word under cursor" },
			{ "<leader>f/", b("current_buffer_fuzzy_find"), desc = "Search in buffer" },
			{ "<leader>fr", b("oldfiles"), desc = "Recent files" },
			{ "<leader>fR", b("resume"), desc = "Resume last picker" },
			{ "<leader>fb", b("buffers"), desc = "Buffers" },
			{ "<leader>fh", b("help_tags"), desc = "Help" },
			{ "<leader>fc", b("commands"), desc = "Commands" },
		}
	end)(),
	opts = {
		defaults = {
			prompt_prefix = "  ",
			selection_caret = " ",
			sorting_strategy = "ascending",
			layout_config = { prompt_position = "top" },
			path_display = { "smart" },
			file_ignore_patterns = { ".git/", "node_modules/", ".cache/" },
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<C-s>"] = "select_horizontal",
					["<C-q>"] = "send_to_qflist",
				},
			},
		},
		pickers = {
			find_files = { hidden = true, follow = true },
			live_grep = {
				additional_args = function()
					return { "--hidden" }
				end,
			},
			oldfiles = { only_cwd = true },
			buffers = { sort_mru = true, ignore_current_buffer = true },
			current_buffer_fuzzy_find = { skip_empty_lines = true },
		},
	},
	config = function(_, opts)
		local t = require("telescope")
		t.setup(opts)
		pcall(t.load_extension, "fzf")
	end,
}
