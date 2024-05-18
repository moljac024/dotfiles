-- ############################################################################
-- Basics
-- ############################################################################
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- ############################################################################
-- Keybinds
-- ############################################################################
vim.g.mapleader = ","
vim.keymap.set("i", "jj", "<Esc>", {
  silent = true,
  noremap = true,
})

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
vim.opt.relativenumber = true

-- ############################################################################
-- Lazy (plugin manager)
-- ############################################################################
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" }, {
  change_detection = {
    notify = false,
  },
})
