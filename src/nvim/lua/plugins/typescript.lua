return {
  { "dmmulroy/ts-error-translator.nvim" },
  {
    "dmmulroy/tsc.nvim",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tsc").setup({
        auto_open_qflist = true,
        use_trouble_qflist = true,
        bin_path = require("util.typescript").find_tsc_bin(),
      })
    end,
  },
}
