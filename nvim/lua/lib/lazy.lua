local M = {}
local git = require("lib.git")

M.init = function(plugins_dir)
  git.ensure_installed("folke/lazy.nvim", { ref = "stable", refresh = false }) -- Package manager

  -- Load list of plugins
  local plugins = require(plugins_dir)

  require("lazy").setup({
    spec = plugins,
    change_detection = {
      notify = false,
    },
  })
end

return M
