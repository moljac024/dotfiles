local c = require("lib.commands")
local logo = require("lib.ui").logo
local lualine_theme = "auto"

return {
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
  {
    "2kabhishek/nerdy.nvim",
    cmd = "Nerdy",
  },
  {
    "famiu/bufdelete.nvim",
    config = function()
      c.add_command({
        {
          desc = "Kill current buffer",
          cmd = "<CMD>Bwipeout<CR>"
        },
        {
          desc = "Kill current buffer (force)",
          cmd = "<CMD>Bwipeout!<CR>"
        }
      })
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
    config = function()
      require("bufferline").setup({
        options = {
          always_show_bufferline = false, -- Don't show bufferline if there is only one item
          mode = "tabs",                  -- Show only tabs, no buffers
          diagnostics = "nvim_lsp",
        },
      })
    end,
  },
  -- Notifications
  {
    "rcarriga/nvim-notify",
    enabled = false,
    config = function()
      local notify = require("notify")
      ---@diagnostic disable-next-line: missing-fields
      notify.setup({
        background_colour = "#000000"
      })

      -- Make this the default notify fn
      vim.notify = notify
    end,
  },
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
}
