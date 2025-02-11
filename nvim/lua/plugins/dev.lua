return {
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
        bin_path = require("lib.typescript").find_tsc_bin(),
      })
    end,
  },
  -- Fennel
  { "jaawerth/fennel.vim" },
  -- REPLs for lisps
  { "Olical/conjure" },
  { "PaterJason/cmp-conjure" },
}
