return {
  -- improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- Improve notifications
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
    -- Keybindings helper
    "FeiyouG/commander.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>fc", "<CMD>Telescope commander<CR>", mode = "n" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("commander").setup({
        components = {
          "DESC",
          "KEYS",
          "CAT",
        },
        sort_by = {
          "DESC",
          "KEYS",
          "CAT",
          "CMD",
        },
        integration = {
          telescope = {
            enable = true,
          },
          lazy = {
            enable = true,
            set_plugin_name_as_cat = true,
          },
        },
      })
    end,
  },
}
