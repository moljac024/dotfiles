local logo = [[
⠀⠀⠀⠀⠀⠀⠀⣠⡤⠶⡄⠀⠀⠀⠀⠀⠀⠀⢠⠶⣦⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣴⣿⡟⠀⠈⣀⣾⣝⣯⣿⣛⣷⣦⡀⠀⠈⢿⣿⣦⡀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣿⣿⡇⠀⢼⣿⣽⣿⢻⣿⣻⣿⣟⣷⡄⠀⢸⣿⣿⣾⣄⠀⠀⠀
⠀⠀⣞⣿⣿⣿⣿⣷⣤⣸⣟⣿⣿⣻⣯⣿⣿⣿⣿⣀⣴⣿⣿⣿⣿⣯⣆⠀⠀
⠀⡼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣜⡆⠀
⢠⣟⣯⣿⣿⣿⣷⢿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣟⠿⣿⣿⣿⣿⡷⣾⠀
⢸⣯⣿⣿⡏⠙⡇⣾⣟⣿⡿⢿⣿⣿⣿⣿⣿⢿⣟⡿⣿⠀⡟⠉⢹⣿⣿⢿⡄
⢸⣯⡿⢿⠀⠀⠱⢈⣿⢿⣿⡿⣏⣿⣿⣿⣿⣿⣿⣿⣿⣀⠃⠀⢸⡿⣿⣿⡇
⢸⣿⣇⠈⢃⣴⠟⠛⢉⣸⣇⣹⣿⣿⠚⡿⣿⣉⣿⠃⠈⠙⢻⡄⠎⠀⣿⡷⠃
⠈⡇⣿⠀⠀⠻⣤⠠⣿⠉⢻⡟⢷⣝⣷⠉⣿⢿⡻⣃⢀⢤⢀⡏⠀⢠⡏⡼⠀
⠀⠘⠘⡅⠀⣔⠚⢀⣉⣻⡾⢡⡾⣻⣧⡾⢃⣈⣳⢧⡘⠤⠞⠁⠀⡼⠁⠀⠀
⠀⠀⠀⠸⡀⠀⢠⡎⣝⠉⢰⠾⠿⢯⡘⢧⡧⠄⠀⡄⢻⠀⠀⠀⢰⠁⠀⠀⠀
⠀⠀⠀⠀⠁⠀⠈⢧⣈⠀⠘⢦⠀⣀⠇⣼⠃⠰⣄⣡⠞⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢤⠼⠁⠀⠀⠳⣤⡼⠀⠀⠀⠀⠀⠀
    ]]
local lualine_theme = "solarized_light"

return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light" -- 'dark' or 'light'

      require("solarized").setup({
        transparent = true,
        palette = "selenized",
        -- theme = "neo",
      })

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
    priority = 997,
    keys = {
      { "<leader>fc", "<CMD>Telescope commander<CR>", mode = "n" },
      { "<leader>P", "<CMD>Telescope commander<CR>", mode = "n" },
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

      require("commander").add({
        {
          desc = "Quit neovim",
          cmd = "<CMD>qall!<CR>",
        },
      }, {
        show = true,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = lualine_theme,
          -- No fancy powerline separators
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true, -- Always show one global status line
        },
        sections = {
          lualine_c = {
            "filename",
            "lsp_progress",
          },
          lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
        },
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      logo = string.rep("\n", 2) .. logo
      require("dashboard").setup({
        config = {
          header = vim.split(logo, "\n"),
        },
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
    -- tag = "0.1.8",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function()
      local data = assert(vim.fn.stdpath("data")) --[[@as string]]
      local telescope = require("telescope")
      -- local themes = require("telescope.themes")
      local actions = require("telescope.actions")

      local default_vertical_layout_config = {
        prompt_position = "bottom",
        height = 0.95,
        width = 0.95,
        preview_height = 0.5,
        preview_cutoff = 24,
      }

      telescope.setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = default_vertical_layout_config,
          },
          mappings = {
            i = {
              -- Close telescope with <esc>. Effectively, it means telescope is only used in insert mode
              ["<esc>"] = "close",
              -- Move selection with <C-j> and <C-k>
              ["<C-j>"] = {
                actions.move_selection_next,
                type = "action",
                opts = { nowait = true, silent = true },
              },
              ["<C-k>"] = {
                actions.move_selection_previous,
                type = "action",
                opts = { nowait = true, silent = true },
              },
            },
          },
        },
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
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      -- local themes = require("telescope.themes")

      vim.keymap.set("n", ";", builtin.resume)
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Search for files" })
      vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "Search for files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Search for string (live grep)" })
      vim.keymap.set("n", "<leader>fg", builtin.grep_string, { desc = "Search for string under cursor" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Look up keymaps" })
      vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Search in jumplist" })

      vim.keymap.set({ "n" }, "<leader>fe", function()
        builtin.symbols({ sources = { "emoji" } })
      end, { desc = "Search for emoji" })

      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Find in buffer" })
    end,
  },
  -- Improve notifications
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
  {
    "folke/which-key.nvim",
    priority = 998,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 350
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "stevearc/stickybuf.nvim",
    opts = {},
    config = function()
      require("stickybuf").setup({
        get_auto_pin = function(bufnr)
          local buftype = vim.bo[bufnr].buftype
          local filetype = vim.bo[bufnr].filetype
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          -- You can return "bufnr", "buftype", "filetype", or a custom function to set how the window will be pinned.
          -- You can instead return an table that will be passed in as "opts" to `stickybuf.pin`.
          -- The function below encompasses the default logic. Inspect the source to see what it does.
          local default = require("stickybuf").should_auto_pin(bufnr)

          if default ~= nil then
            return default
          elseif filetype == "Outline" then
            return "filetype"
          else
            return nil
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Pin the buffer to any window that is fixed width or height",
        callback = function(args)
          local stickybuf = require("stickybuf")
          if not stickybuf.is_pinned() and (vim.wo.winfixwidth or vim.wo.winfixheight) then
            stickybuf.pin()
          end
        end,
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
        },
      })
    end,
  },
}
