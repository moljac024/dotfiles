-- ############################################################################
-- ## Code formatting
-- ############################################################################

vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

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

-- ############################################################################
-- ## Sane commenting for JSX/TSX and other mixed language files
-- ############################################################################

vim.pack.add({
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
})

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

-- ############################################################################
-- ## Auto tags
-- ############################################################################

vim.pack.add({
  "https://github.com/windwp/nvim-ts-autotag",
})

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
