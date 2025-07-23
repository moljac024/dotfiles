local M = {}
local git = import("./git")

M.init = function()
  local lazy_path = git.ensure_installed("folke/lazy.nvim", { ref = "stable", refresh = false })       -- Package manager
  local hotpot_path = git.ensure_installed("rktjmp/hotpot.nvim", { ref = "v0.14.8", refresh = false }) -- Fennel compiler

  -- As per Lazy's install instructions, but also include hotpot
  vim.opt.runtimepath:prepend({ hotpot_path, lazy_path })
  -- You must call vim.loader.enable() before requiring hotpot unless you are
  -- passing {performance = {cache = false}} to Lazy.
  vim.loader.enable()
  require("hotpot")

  -- Load list of plugins
  local plugins = require("plugins")

  require("lazy").setup({
    spec = vim.list_extend({ "rktjmp/hotpot.nvim" }, plugins),
    change_detection = {
      notify = false,
    },
  })
end

return M
