-- ############################################################################
-- Keybindings
-- ############################################################################
vim.g.mapleader = ","
vim.keymap.set("i", "jj", "<Esc>", {
  silent = true,
  noremap = true,
})

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

-- ############################################################################
-- Basics
-- ############################################################################
-- enable 24-bit colour
vim.opt.termguicolors = true

-- ############################################################################
-- Formatting
-- ############################################################################
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- ############################################################################
-- Misc
-- ############################################################################
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
