return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true },
        panel = { enabled = true },
      })

      vim.keymap.set({ "n" }, "<leader>cp", function()
        require("copilot.panel").open({
          ratio = 0.5,
          position = "bottom",
        })
      end, { desc = "Open copilot", commander = { cat = "copilot" } })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  { "AndreM222/copilot-lualine" },
}
