local lualine_theme = "auto"

return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- The neovim plugin standard library
  {
    "folke/snacks.nvim",
    priority = 1000,
    -- enabled = false,
    lazy = false,
    opts = {
      rename = {},
      input = {},
      git = {},
      image = {},
    }
  },
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require('mini.extra').setup()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.icons').setup()
      require('mini.diff').setup()
      require('mini.pick').setup({
        mappings = {
          move_down = '<C-j>',
          move_up   = '<C-k>',
        }
      })

      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })

      local function override_select()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(items, opts, on_choice)
          local start_opts = { window = { config = { width = vim.o.columns } } }
          ---@diagnostic disable-next-line: undefined-global
          return MiniPick.ui_select(items, opts, on_choice, start_opts)
        end
      end

      override_select()

      vim.keymap.set('n', '<leader>f', function()
        MiniPick.builtin.files()
      end, { desc = 'Open file picker', commander = {} })

      vim.keymap.set('n', '<leader>b', function()
        MiniPick.builtin.buffers()
      end, { desc = 'Open buffer picker', commander = {} })

      vim.keymap.set('n', '<leader>/', function()
        MiniPick.builtin.grep_live()
      end, { desc = 'Open global search picker', commander = {} })

      vim.keymap.set('n', '<leader>h', function()
        MiniPick.builtin.help()
      end, { desc = 'Open help picker', commander = {} })

      vim.keymap.set('n', "<leader>'", function()
        MiniPick.builtin.resume()
      end, { desc = 'Open last picker', commander = {} })
    end
  },
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 999,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        float = {
          solid = false,
          transparent = true,
        },
        transparent_background = not vim.g.neovide,
        -- transparent_background = vim.g.transparent_enabled,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "folke/which-key.nvim",
    priority = 998,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 350
    end,
    config = function()
      require("which-key").setup({
        preset = "helix" -- classic | modern | helix
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
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
                local has_hbac, hbac_state = pcall(require, "hbac.state")
                if not has_hbac then
                  return ""
                end

                local cur_buf = vim.api.nvim_get_current_buf()
                return hbac_state.is_pinned(cur_buf) and "󰐃" or ""
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
  -- Notifications
  {
    "j-hui/fidget.nvim",
    config = function()
      local fidget = require("fidget")
      fidget.setup({
        notification = {
          window = {
            -- border: "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
            border = "double",
            -- Make sure window is transparent
            winblend = 0,
            -- Make sure notifications are high enough (the default 45 doesn't
            -- cover telescope, for example)
            zindex = 250,
          },
        },
      })

      -- Make this the default notify fn
      local function notify(msg, level, opts)
        -- Fidget uses key where some other implementations use id. Standardize
        -- and make both behave the same
        if opts and opts.id ~= nil then
          opts.key = opts.id
        elseif opts and opts.key ~= nil then
          opts.id = opts.key
        end
        return fidget.notify(msg, level, opts)
      end
      vim.notify = notify

      local has_telescope, telescope = pcall(require, "telescope")
      if has_telescope then
        telescope.load_extension("fidget")
      end
    end
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      local hover = require("hover")

      hover.config({
        providers = {
          'hover.providers.lsp',
          'hover.providers.diagnostic',
          'hover.providers.dap',
          'hover.providers.man',
          'hover.providers.dictionary',
          -- Optional, disabled by default:
          -- 'hover.providers.gh',
          -- 'hover.providers.gh_user',
          -- 'hover.providers.jira',
          'hover.providers.fold_preview',
          -- 'hover.providers.highlight',
        },
        preview_opts = {
          border = "single",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
        mouse_providers = {
          "hover.providers.lsp",
        },
        mouse_delay = 1000,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", function()
        if vim.bo.filetype ~= 'help' then
          hover.open()
        else
          vim.api.nvim_feedkeys("K", 'ni', true)
        end
      end, { desc = "Hover (open)" })
      vim.keymap.set("n", "<leader>k", hover.open, { desc = "Hover (open)" })
      vim.keymap.set("n", "gK", hover.enter, { desc = "Hover (enter)" })
    end,
  },
  -- Clean up old buffers
  {
    "axkirillov/hbac.nvim",
    config = function()
      local hbac = require("hbac")
      hbac.setup({
        -- set autoclose to false if you want to close manually
        autoclose = true,
        -- hbac will start closing unedited buffers once that number is reached
        threshold = 10,
        close_command = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
        -- hbac will close buffers with associated windows if this option is `true`
        close_buffers_with_windows = false,
      })
    end,
  },
}
