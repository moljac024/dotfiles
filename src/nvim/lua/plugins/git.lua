return {
  {
    "f-person/git-blame.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("gitsigns").setup()
    end,
  },
}
