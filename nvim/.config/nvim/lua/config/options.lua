local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.statuscolumn = "%=%5{v:relnum ? v:relnum : v:lnum} %s"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 400
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.cursorline = true
opt.splitbelow = true
opt.splitright = true
opt.fillchars:append({ eob = " " })
