return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- The neovim plugin standard library
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      rename = {},
      input = {},
      git = {},
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
        preset = {
          pick = nil,
          keys = {
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
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
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.icons').setup()
    end
  },
}
