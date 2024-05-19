return {
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
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
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
