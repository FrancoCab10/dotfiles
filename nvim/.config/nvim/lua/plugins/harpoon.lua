return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  lazy = false,
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)

    local list = function() return harpoon:list() end
    local sel  = function(i) return function() list():select(i) end end

    -- Harpoon <-> Telescope picker
    local function harpoon_telescope()
      local pickers  = require("telescope.pickers")
      local finders  = require("telescope.finders")
      local conf     = require("telescope.config").values
      local actions  = require("telescope.actions")
      local state    = require("telescope.actions.state")

      local l = list()
      local items = {}
      for i, item in ipairs(l.items) do
        table.insert(items, { idx = i, path = item.value })
      end

      pickers.new({}, {
        prompt_title = "Harpoon",
        finder = finders.new_table({
          results = items,
          entry_maker = function(e)
            return {
              value   = e.idx,
              ordinal = e.path,
              display = string.format("%d  %s", e.idx, e.path),
              path    = e.path,
            }
          end,
        }),
        sorter    = conf.generic_sorter({}),
        previewer = conf.file_previewer({}),
        attach_mappings = function(_, map)
          local pick = function(buf)
            local entry = state.get_selected_entry()
            actions.close(buf)
            l:select(entry.value)
          end
          map("i", "<CR>", pick)
          map("n", "<CR>", pick)
          return true
        end,
      }):find()
    end

    -- Keymaps (leader)
    vim.keymap.set("n", "<leader>ha", function() list():add() end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>ht", harpoon_telescope, { desc = "Harpoon telescope" })
    vim.keymap.set("n", "<leader>hc", function() list():clear() end, { desc = "Harpoon clear files" })
    vim.keymap.set("n", "<leader>h1", sel(1), { desc = "Harpoon 1" })
    vim.keymap.set("n", "<leader>h2", sel(2), { desc = "Harpoon 2" })
    vim.keymap.set("n", "<leader>h3", sel(3), { desc = "Harpoon 3" })
    vim.keymap.set("n", "<leader>h4", sel(4), { desc = "Harpoon 4" })

    -- Ctrl+1..4 to jump (terminal must support these keycodes)
    for i = 1, 4 do
      vim.keymap.set("n", "<C-" .. i .. ">", sel(i), { desc = "Harpoon " .. i, silent = true })
    end
  end,
}
