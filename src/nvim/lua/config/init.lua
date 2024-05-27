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
vim.opt.updatetime = 200 -- Faster updatetime
vim.opt.termguicolors = true -- enable 24-bit colour

vim.opt.signcolumn = "yes"
vim.opt.wrap = false -- Don't wrap lines
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

-- ############################################################################
-- Keybindings
-- ############################################################################
vim.g.mapleader = " "
vim.g.maplocalleader = "<Backspace>"
vim.keymap.set({ "i", "c" }, "jj", "<C-c><Esc>", {
  silent = true,
  noremap = true,
})

-- Basic movement keybinds, these make navigating splits easy for me
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

vim.keymap.set("n", "<leader><leader>", "<c-^>") -- Go to prev buffer
vim.keymap.set("n", "<leader>g;", "<c-o>") -- Go back

-- Y will yank from the cursor to the end of the line, to be consistent with C and D.
vim.keymap.set("n", "Y", "y$")

-- Visual shifting (does not exit Visual mode)
vim.keymap.set({ "v", "x" }, "<", "<gv")
vim.keymap.set({ "v", "x" }, ">", ">gv")

-- Format selected text or paragraph with Q
vim.keymap.set("v", "Q", "gq")
vim.keymap.set({ "n" }, "Q", "gqap")

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<CMD>noh<CR>")

-- Window splits
vim.keymap.set({ "n" }, "<leader>2", ":sp<cr>") -- Split window horizontally
vim.keymap.set({ "n" }, "<leader>3", ":vsp<cr>") -- Split window vertically
vim.keymap.set({ "n" }, "<leader>1", "<c-w>o") -- Close other windows
vim.keymap.set({ "n" }, "<leader>4", "<c-w>c") -- Close current window
vim.keymap.set({ "n" }, "<leader>0", "<c-w>c") -- Close current window

-- Buffers
vim.keymap.set("n", "<leader><Backspace>", ":bw<cr>") -- Kill buffer
