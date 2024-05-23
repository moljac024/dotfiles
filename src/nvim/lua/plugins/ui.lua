return {
  {
    "rcarriga/nvim-notify",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      local notify = require("notify")

      -- Make this the default notify fn
      vim.notify = notify
    end,
  },
  {
    "2kabhishek/nerdy.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
}
