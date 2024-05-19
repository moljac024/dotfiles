return {
  {
    "maxmx03/solarized.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "light" -- 'dark' or 'light'

      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        theme = "solarized_light",
      })
    end,
  },
}
