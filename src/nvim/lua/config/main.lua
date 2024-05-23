-- ############################################################################
-- Basics
-- ############################################################################
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Faster updatetime
vim.opt.updatetime = 200

-- enable 24-bit colour
vim.opt.termguicolors = true

-- ############################################################################
-- Keybindings
-- ############################################################################
vim.g.mapleader = ","
vim.keymap.set({ "i", "c" }, "jj", "<C-c><Esc>", {
  silent = true,
  noremap = true,
})

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

-- Faster browsing/scrolling
vim.keymap.set({ "n", "v" }, "<space>", "<c-f>")
vim.keymap.set({ "n", "v" }, "<s-space>", "<c-b>")
vim.keymap.set({ "n", "v" }, "<backspace>", "<c-b>")

-- Y will yank from the cursor to the end of the line, to be consistent with C and D.
vim.keymap.set("n", "Y", "y$")

-- Visual shifting (does not exit Visual mode)
vim.keymap.set({ "v", "x" }, "<", "<gv")
vim.keymap.set({ "v", "x" }, ">", ">gv")

-- Format selected text or paragraph with Q
vim.keymap.set("v", "Q", "gq")
vim.keymap.set({ "n" }, "Q", "gqap")

-- Window splits
vim.keymap.set({ "n" }, "<leader>2", ":sp<cr>") -- Split window horizontally
vim.keymap.set({ "n" }, "<leader>3", ":vsp<cr>") -- Split window vertically
vim.keymap.set({ "n" }, "<leader>1", "<c-w>o") -- Close other windows
vim.keymap.set({ "n" }, "<leader>4", "<c-w>c") -- Close current window
vim.keymap.set({ "n" }, "<leader>0", "<c-w>c") -- Close current window

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
