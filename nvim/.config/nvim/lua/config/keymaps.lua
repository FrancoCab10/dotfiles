local map = vim.keymap.set

-- =========== WINDOW MANAGEMENT ===========
-- Window management
map("n", "<leader>wv", "<CMD>vsplit<CR>", { desc = "Window vertical split" })
map("n", "<leader>wh", "<CMD>split<CR>",  { desc = "Window horizontal split" })
map("n", "<leader>we", "<C-w>=",          { desc = "Window equalize sizes" })
map("n", "<leader>wq", "<CMD>close<CR>",  { desc = "Window close" })

-- Move between windows
map("n", "<C-h>", "<C-w>h", { desc = "Focus window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus window right" })

-- Resize windows
map("n", "<C-Up>",    "<CMD>resize +2<CR>",           { desc = "Resize window taller" })
map("n", "<C-Down>",  "<CMD>resize -2<CR>",           { desc = "Resize window shorter" })
map("n", "<C-Left>",  "<CMD>vertical resize +4<CR>",  { desc = "Resize window narrower" })
map("n", "<C-Right>", "<CMD>vertical resize -4<CR>",  { desc = "Resize window wider" })

-- =========== NAVIGATION ===========
map("n", "gb", "<C-o>", { desc = "Go back" })
map("n", "gB", "<C-i>", { desc = "Go forward" })
