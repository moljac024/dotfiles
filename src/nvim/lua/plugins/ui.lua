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
    priority = 1100,
    config = function()
      local neovide = vim.g.neovide
      vim.o.background = "light" -- 'dark' or 'light'

      require("solarized").setup({
        transparent = not neovide,
        palette = "selenized",
        -- theme = "neo",
      })

      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup()
      require("transparent").clear_prefix("BufferLine")
      -- require("transparent").clear_prefix("lualine")

      vim.keymap.set("n", "utt", "<CMD>TransparentToggle<CR>", { desc = "Transparency toggle", commander = {} })
      vim.keymap.set("n", "ut1", "<CMD>TransparentEnable<CR>", { desc = "Transparency enable", commander = {} })
      vim.keymap.set("n", "ut0", "<CMD>TransparentDisable<CR>", { desc = "Transparency disable", commander = {} })
    end,
  },
  {
    "folke/which-key.nvim",
    priority = 999,
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
    -- Keybindings helper
    "FeiyouG/commander.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    priority = 998,
    keys = {},
    config = function()
      local commander = require("commander")
      ---@diagnostic disable-next-line: missing-fields
      commander.setup({
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

      vim.keymap.set({ "n" }, "<leader>fc", "<CMD>Telescope commander<CR>", { desc = "Open commander" })
      vim.keymap.set({ "n" }, "<leader>p", "<CMD>Telescope commander<CR>", { desc = "Open commander" })

      commander.add({
        {
          desc = "Quit/Exit",
          cmd = "<CMD>qall!<CR>",
        },
      }, {
        show = true,
      })

      -- Add telescope builtin searches
      local telescope_builtin = require("telescope.builtin")
      commander.add({
        {
          desc = "Resume previous search",
          keys = {
            { "n", "<leader>f;" },
          },
          cmd = telescope_builtin.resume,
        },
        {
          desc = "Search files",
          keys = {
            { "n", "<leader>ff" },
          },
          cmd = telescope_builtin.find_files,
        },
        {
          desc = "Search buffers",
          keys = {
            { "n", "<leader>fb" },
          },
          cmd = telescope_builtin.buffers,
        },
        {
          desc = "Search help",
          keys = {
            { "n", "<leader>fh" },
          },
          cmd = telescope_builtin.help_tags,
        },
        {
          desc = "Search for string (live grep)",
          keys = {
            { "n", "<leader>fs" },
          },
          cmd = telescope_builtin.live_grep,
        },
        {
          desc = "Search for string under cursor",
          keys = {
            { "n", "<leader>fg" },
          },
          cmd = telescope_builtin.grep_string,
        },
        {
          desc = "Search keymaps",
          keys = {

            { "n", "<leader>fk" },
          },
          cmd = telescope_builtin.keymaps,
        },
        {
          desc = "Search jumplist",
          keys = {
            { "n", "<leader>fj" },
          },
          cmd = telescope_builtin.jumplist,
        },
        {
          desc = "Find in buffer",
          keys = {
            { "n", "<leader>/" },
          },
          cmd = telescope_builtin.current_buffer_fuzzy_find,
        },
        {
          desc = "Search emoji",
          keys = {
            { "n", "<leader>fe" },
          },
          cmd = function()
            telescope_builtin.symbols({ sources = { "emoji" } })
          end,
        },
        {
          desc = "Switch to project",
          keys = {
            { "n", "<leader>fp" },
          },
          cmd = "<CMD>Telescope projects<CR>",
        },
      }, { set = true, show = true, cat = "telescope" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "axkirillov/hbac.nvim",
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
            {
              function()
                local cur_buf = vim.api.nvim_get_current_buf()
                return require("hbac.state").is_pinned(cur_buf) and "📍" or ""
                -- tip: nerd fonts have pinned/unpinned icons!
              end,
              color = { fg = "#ef5f6b", gui = "bold" },
            },
            "filename",
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
  -- LSP progress notifications
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          -- border: "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
          border = "single",
          winblend = 0, -- Important!
        },
      },
    },
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
    "famiu/bufdelete.nvim",
    config = function()
      vim.keymap.set("n", "<leader>bk", ":Bwipeout<CR>", { desc = "Kill current buffer", commander = {} })
      vim.keymap.set("n", "<leader>bK", ":Bwipeout!<CR>", { desc = "Kill current buffer (force)", commander = {} })
    end,
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
            return nil -- There are some issues with using stickybuf with outline plugin
          -- return "filetype"
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
