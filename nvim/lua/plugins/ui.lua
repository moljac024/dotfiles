local c = require("lib.command")
local lualine_theme = "auto"

return {
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 999,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
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
    -- Keybindings helper
    "FeiyouG/commander.nvim",
    lazy = false,
    priority = 996,
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

      vim.keymap.set({ "n" }, "<leader><leader>", "<CMD>Telescope commander<CR>", { desc = "Open commander" })

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
          desc = "Open last picker",
          keys = {
            { "n", "<leader>'" },
          },
          cmd = telescope_builtin.resume,
        },
        {
          desc = "Open file picker",
          keys = {
            { "n", "<leader>f" },
          },
          cmd = telescope_builtin.find_files,
        },
        {
          desc = "Open buffer picker",
          keys = {
            { "n", "<leader>b" },
          },
          cmd = telescope_builtin.buffers,
        },
        {
          desc = "Open help picker",
          keys = {
            { "n", "<leader>?" },
          },
          cmd = telescope_builtin.help_tags,
        },
        {
          desc = "Global search in workspace",
          keys = {
            { "n", "<leader>/" },
          },
          cmd = telescope_builtin.live_grep,
        },
        {
          desc = "Open jumplist picker",
          keys = {
            { "n", "<leader>j" },
          },
          cmd = telescope_builtin.jumplist,
        },
        {
          desc = "Find in buffer",
          keys = {
            { "n", "<leader>\\" },
          },
          cmd = telescope_builtin.current_buffer_fuzzy_find,
        },
        {
          desc = "Open symbol picker",
          keys = {
            { "n", "<leader>s" },
          },
          cmd = telescope_builtin.lsp_document_symbols,
        },
        {
          desc = "Open workspace symbol picker",
          keys = {
            { "n", "<leader>S" },
          },
          cmd = telescope_builtin.lsp_workspace_symbols
        },
        {
          desc = "Insert emoji",
          cmd = function()
            telescope_builtin.symbols({ sources = { "emoji" } })
          end,
        },
      }, { set = true, show = true, cat = "telescope" })
    end,
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
  {
    'nanozuki/tabby.nvim',
    config = function()
      -- Show tabline always
      vim.o.showtabline = 2

      local theme = {
        fill = 'TabLineFill',
        head = 'TabLine',
        current_tab = 'TabLineSel',
        tab = 'TabLineSel',
        win = 'TabLineSel',
        tail = 'TabLineSel',
      }

      require('tabby').setup({
        preset = "active_wins_at_tail",
        lualine_theme = lualine_theme,
        tab_name = {
          name_fallback = function(tabid)
            return tabid
          end,
        },
        buf_name = {
          mode = 'unique', -- or 'relative', 'tail', 'shorten'
        },
        line = function(line)
          return {
            {
              { '   ', hl = theme.head },
              line.sep('', theme.head, theme.fill),
            },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep('', hl, theme.fill),
                tab.is_current() and '' or '',
                ' ',
                tab.number(),
                tab.name(),
                tab.close_btn(''),
                line.sep(' ', hl, theme.fill),
                hl = hl,
                margin = ' ',
              }
            end),
            line.spacer(),
            line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
              return {
                line.sep(' ', theme.win, theme.fill),
                win.is_current() and '' or '',
                ' ',
                win.buf_name(),
                line.sep(' ', theme.win, theme.fill),
                hl = theme.win,
                margin = ' ',
              }
            end),
            {
              line.sep(' ', theme.tail, theme.fill),
              { '  ', hl = theme.tail },
            },
            hl = theme.fill,
          }
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    priority = 997,
    -- tag = "0.1.8",
    branch = "0.1.x",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function()
      local data = assert(vim.fn.stdpath("data")) --[[@as string]]
      local telescope = require("telescope")
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
    -- Pretty quickfix window
    "yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup()
    end,
  },
}
