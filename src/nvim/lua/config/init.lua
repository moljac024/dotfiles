-- ############################################################################
-- Options
-- ############################################################################

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.backup = false -- no backup file
vim.opt.swapfile = false -- no swapfile
vim.opt.undofile = true -- enable persistent undo
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.updatetime = 2000 -- Faster updatetime, default is 4000
vim.opt.termguicolors = true -- enable 24-bit colour

vim.opt.laststatus = 3 -- Always show one status line
vim.opt.signcolumn = "yes"
vim.opt.wrap = true -- Wrap lines
vim.opt.scrolloff = 8 -- Make sure there are always some lines of context
vim.opt.sidescrolloff = 8 -- Make sure there are always some lines of context
vim.opt.number = true
-- vim.opt.relativenumber = true -- Show relative numbers except the current line
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.o.inccommand = "split"

-- Keybindings leader
vim.g.mapleader = ","
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<BS>", false, false, true) -- Backspace as local leader
-- vim.g.maplocalleader = " " -- Space as local leader

-- Keybinds timeout
vim.opt.timeout = true -- Enable timeout
vim.opt.timeoutlen = 1000 -- By default timeoutlen is 1000 ms
