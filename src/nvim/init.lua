-- ############################################################################
-- Init script
-- ############################################################################
require("config")

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
  },
  change_detection = {
    notify = false,
  },
})
