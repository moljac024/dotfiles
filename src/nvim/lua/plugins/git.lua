return {
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
    end,
    commander = {
      {
        cmd = "<CMD>GitBlameToggle<CR>",
        desc = "Toggle git blame",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({})
      vim.keymap.set("n", "<C-g>", "<cmd>Neogit<cr>")
    end,
    commander = {
      {
        cmd = "<CMD>Neogit<CR>",
        desc = "Open git ui (Neogit)",
      },
    },
  },
}
