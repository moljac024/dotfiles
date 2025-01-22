return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = true,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  { "AndreM222/copilot-lualine", enabled = true },
}
