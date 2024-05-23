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
    "lewis6991/gitsigns.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("gitsigns").setup()
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
    config = function()
      local neogit = require("neogit")
      neogit.setup({})
      vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
    end,
  },
}
