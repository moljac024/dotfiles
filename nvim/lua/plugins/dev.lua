local c = require("lib.command")

return {
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    -- enabled = false,
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()

      vim.keymap.set("n", "<leader>g", "<CMD>Gitsigns blame_line<CR>",
        { desc = "Hover git blame for current line", commander = {} })

      c.add_command({
        {
          desc = "Toggle git blame on cursor line",
          cmd = gitsigns.toggle_current_line_blame
        },
        {
          desc = "Open git blame",
          cmd = "<CMD>Gitsigns blame<CR>"
        }
      })
    end,
  },
  -- Tailwind and typescript
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim" },
  {
    "dmmulroy/tsc.nvim",
    lazy = true,
    cmd = "TSC",
    commander = {
      {
        cmd = "<CMD>TSC<CR>",
        desc = "Typecheck typescript project",
      },
    },
    config = function()
      local tsc = require("tsc")
      ---@diagnostic disable-next-line: missing-fields
      tsc.setup({
        auto_open_qflist = true,
        use_trouble_qflist = true,
      })
    end,
  },
  -- KMonad syntax
  { 'kmonad/kmonad-vim' },
  -- Fennel
  { "jaawerth/fennel.vim" },
}
