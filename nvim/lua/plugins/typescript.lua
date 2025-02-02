return {
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
        bin_path = require("util.typescript").find_tsc_bin(),
      })
    end,
  },
}
