-- ############################################################################
-- Setup
-- ############################################################################

-- Monkey patch vim's keybind.set so that it supports integration with commander
local keybinds_util = require("util.keybinds")
keybinds_util.patch_keymap_set_for_commander()

-- ############################################################################
-- Config
-- ############################################################################

if not vim.g.vscode then
  require("config")
else
  require("vscode.config")
end

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

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      import = "plugins",
      cond = function()
        return not vim.g.vscode
      end,
    },
    {
      import = "vscode/plugins",
      cond = function()
        return vim.g.vscode
      end,
    },
  },
  change_detection = {
    notify = false,
  },
})

-- ############################################################################
-- Keybindings
-- ############################################################################

if not vim.g.vscode then
  require("config.keybinds")
end
