return {
  {
    "nvimdev/dashboard-nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        -- config
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
