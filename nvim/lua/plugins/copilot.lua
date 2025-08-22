return {
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
}
