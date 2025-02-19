local c = require("lib.commands")

return {
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    -- enabled = false,
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()

      c.add_command(
        {
          desc = "Toggle git blame for current line",
          cmd = gitsigns.toggle_current_line_blame
        }
      )
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
  -- Fennel
  { "jaawerth/fennel.vim" },
  -- REPLs for lisps
  { "Olical/conjure" },
  { "PaterJason/cmp-conjure" },
}
