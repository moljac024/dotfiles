return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- The neovim plugin standard library
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      rename = { enabled = true },
      input = { enabled = true },
      picker = {
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            }
          }
        }
      },
      image = {},
    }
  },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.comment').setup()
      -- require('mini.pairs').setup()
      require('mini.icons').setup()
      require('mini.git').setup()
      -- require('mini.jump2d').setup() -- Jump to any 2 character location
    end
  },
}
