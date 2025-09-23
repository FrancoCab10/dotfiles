return {
  "stevearc/oil.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", optional = true },
  },
  opts = {
    default_file_explorer = true,
    columns = { "icon" },
    win_options = { signcolumn = "yes:2" },
    view_options = {
      show_hidden = true,
      is_hidden_file = function(_) return false end,
      is_always_hidden = function(_) return false end,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        -- If not in Oil, just open it and return
        if vim.bo.filetype ~= "oil" then
          require("oil").open()
          return
        end

        -- If in Oil but no alternate buffer, do nothing
        local alt = vim.fn.bufnr("#")
        if alt <= 0 or not vim.api.nvim_buf_is_valid(alt) or not vim.api.nvim_buf_is_loaded(alt) then
          return
        end

        -- Otherwise, go back to the alternate buffer
        vim.cmd("b#")
      end,
      desc = "Explorer",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("oil").open(data.file)
        end
      end,
    })
  end,
}
