return {
  {
    -- Use formatters to format code
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
        }
      })

      Lib.command.add_commands({
        {
          desc = "Save current buffer (without autocmd)",
          cmd = function()
            vim.cmd("noautocmd write")
          end
        },
      })
    end,
  },
  {
    -- Remove trailing whitespace and empty lines at EOF on file save
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
}
