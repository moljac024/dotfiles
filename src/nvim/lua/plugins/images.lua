return {
  {
    "edluffy/hologram.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("hologram").setup({
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      })
    end,
  },
}
