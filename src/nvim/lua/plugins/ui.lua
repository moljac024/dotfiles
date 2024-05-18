return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")

      -- Make this the default notify fn
      vim.notify = notify
    end,
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
}
