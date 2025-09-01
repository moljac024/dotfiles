local lualine_theme = "auto"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    -- enabled = false,
    lazy = false,
    opts = {
      rename = {},
      input = {},
      git = {},
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
        preset = {
          pick = nil,
          keys = {
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      image = {},
    }
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
                tab.in_jump_mode() and tab.jump_key() or tab.number(),
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

      -- Set up keybinds
      vim.keymap.set("n", "<leader>tr", ":Tabby rename_tab ", { desc = "Rename tab", commander = {} })
      vim.keymap.set("n", "<leader>tj", "<CMD>Tabby pick_window<CR>", { desc = "Pick window", commander = {} })
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
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
}
