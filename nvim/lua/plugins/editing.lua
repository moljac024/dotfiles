local c = require("lib.command")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true,
        ignore_install = {},
        modules = {},
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "elixir",
          "heex",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "sql",
          "css",
          "html",
          "xml",
          "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        disable = function(lang, buf)
          local max_filesize = 200 * 1024 -- Max file size in KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      })
    end,
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<A-o>", "<cmd>Outline<CR>",
        { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          insert          = '<C-g>z',
          insert_line     = 'gC-ggZ',
          normal          = 'gz',
          normal_cur      = 'gZ',
          normal_line     = 'gzz',
          normal_cur_line = 'gZZ',
          visual          = 'gz',
          visual_line     = 'gZ',
          delete          = 'gzd',
          change          = 'gzc',
        }
      })
    end,
  },
  {
    -- Sane commenting for JSX/TSX and other mixed language files
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      ---@diagnostic disable: missing-fields
      vim.g.skip_ts_context_commentstring_module = true
      ---@diagnostic disable-next-line: missing-fields
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true,           -- Auto close tags
          enable_rename = true,          -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          -- ["html"] = {
          --   enable_close = false,
          -- },
        },
      })
    end,
  },
  -- Remove trailing whitespace and empty lines at EOF on file save
  {
    "mcauley-penney/tidy.nvim",
    opts = {
      enabled_on_save = true,
    },
    init = function()
      local tidy = require("tidy")

      c.add_commands({
        {
          desc = "Toggle tidy",
          cmd = tidy.toggle
        },
        {
          desc = "Format file",
          cmd = tidy.toggle
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()
        end,
      })
    end,
  },
  -- Use formatters to format code
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Conform will run the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        },
        format_after_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
}
