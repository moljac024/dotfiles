-- ############################################################################
-- Options
-- ############################################################################

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- the encoding written to a file
vim.opt.fileencoding = "utf-8"
-- allows neovim to access the system clipboard
vim.opt.clipboard = "unnamedplus"
-- no backup file
vim.opt.backup = false
-- no swapfile
vim.opt.swapfile = false
-- enable persistent undo
vim.opt.undofile = true
-- if a file is being edited by another program (or was written to file while
-- editing with another program), it is not allowed to be edited
vim.opt.writebackup = false
vim.opt.showmode = false
-- Faster updatetime, default is 4000
vim.opt.updatetime = 2000
-- enable 24-bit colour
vim.opt.termguicolors = true

-- Always show one status line
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
-- Wrap lines
vim.opt.wrap = true
-- Make sure there are always some lines of context
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- Show line numbers
-- vim.opt.number = true
-- Show relative numbers except the current line
-- vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.o.inccommand = "split"

-- Keybindings leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- backspace as local leader
-- vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<BS>", false, false, true)

-- Keybinds timeout
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Restore cursor to where it last was in file
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "return cursor to where it was last time closing the file",
  pattern = "*",
  command = 'silent! normal! g`"zv',
})

-- Neovide specific settings
if vim.g.neovide then
  require("config.neovide")
end
