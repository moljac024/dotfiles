return {
  {
    "maxmx03/solarized.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light" -- 'dark' or 'light'

      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    -- Keybindings helper
    "FeiyouG/commander.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    priority = 999,
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
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        theme = "solarized_light",
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        -- config
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  -- improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
      local data = assert(vim.fn.stdpath("data")) --[[@as string]]

      require("telescope").setup({
        extensions = {
          fzf = {},
          wrap_results = true,
          history = {
            path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
            limit = 100,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      -- local themes = require("telescope.themes")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)

      vim.keymap.set("n", "<leader>gw", builtin.grep_string)

      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
    end,
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
}