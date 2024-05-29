return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      local fterm = require("FTerm")
      vim.keymap.set("n", "<A-i>", function()
        fterm.toggle()
      end)
      vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
  },
}
