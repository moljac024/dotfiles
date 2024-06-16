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
-- vim.g.mapleader = "," -- Comma as leader
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<BS>", false, false, true) -- Backspace as local leader
-- vim.g.maplocalleader = " " -- Space as local leader

-- Keybinds timeout
vim.opt.timeout = true -- Enable timeout
vim.opt.timeoutlen = 500 -- By default timeoutlen is 1000 ms

-- Restore cursor to where it last was in file
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "return cursor to where it was last time closing the file",
  pattern = "*",
  command = 'silent! normal! g`"zv',
})

-- Neovide specific settings
if vim.g.neovide then
  -- Font
  vim.opt.guifont = "FiraCode Nerd Font:h16"
  -- Floating window blur
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_fullscreen = true -- Use windowed fullscreen
  vim.g.neovide_transparency = 0.9 -- Window transparency
  vim.g.neovide_cursor_animate_in_insert_mode = true -- Animate cursor in insert mode
  vim.g.neovide_cursor_vfx_mode = "sonicboom" -- Particles on cursor animation

  -- Sane copy/paste
  vim.keymap.set("v", "<SC-C>", '"+y', { noremap = true })
  vim.keymap.set("n", "<SC-V>", '"+P', { noremap = true })
  vim.keymap.set("v", "<SC-V>", '"+P', { noremap = true })
  vim.keymap.set("c", "<SC-V>", '<C-o>"+<C-o>P', { noremap = true })
  vim.keymap.set("i", "<SC-V>", '<ESC>"+Pi', { noremap = true })
  vim.keymap.set("t", "<SC-V>", '<C-\\><C-n>"+Pi', { noremap = true })
end
