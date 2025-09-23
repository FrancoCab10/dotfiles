return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    live_update = true,
    open_cmd = "vnew",
  },
  config = function(_, opts)
    local spectre = require("spectre")
    spectre.setup(opts)

    local map = vim.keymap.set
    local cword = function() return vim.fn.expand("<cword>") end

    -- openers
    map("n", "<leader>rr", function() spectre.open_file_search() end,                             { desc = "replace (current file)" })
    map("n", "<leader>rR", function() spectre.open() end,                                         { desc = "replace (project)" })
    map("n", "<leader>rw", function() spectre.open_file_search({ select_word = true }) end,       { desc = "replace word (current file)" })
    map("n", "<leader>rW", function() spectre.open({ search_text = cword() }) end,                { desc = "replace word (project)" })

    -- accept actions inside spectre panel
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "spectre_panel",
      callback = function(ev)
        local a = require("spectre.actions")
        -- one-by-one: run replace for the current result line
        vim.keymap.set("n", "<localleader>a", a.run_current_replace, { buffer = ev.buf, desc = "apply current match" })
        -- all at once: run replace for all results
        vim.keymap.set("n", "<localleader>A", a.run_replace,         { buffer = ev.buf, desc = "apply all matches" })
      end,
    })
  end,
}

