return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
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
          "json",
          "sql",
          "css",
          "html",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
