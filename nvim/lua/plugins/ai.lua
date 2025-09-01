return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    lazy = true,
    cmd = "Copilot",
    event = 'InsertEnter',
    config = function()
      require("copilot").setup({})
    end
  },
  { 'AndreM222/copilot-lualine' },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  -- Codecompanion
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
