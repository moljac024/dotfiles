return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })

      -- local cmp_ok, cmp = pcall(require, "cmp")
      -- local panel = require("copilot.panel")
      -- local suggestion = require("copilot.suggestion")

      -- vim.keymap.set({ "i" }, "<C-;>", function()
      --   if cmp_ok then
      --     if cmp.visible() then
      --       cmp.close()
      --     end
      --   end
      --
      --   if not suggestion.is_visible() then
      --     suggestion.next()
      --   else
      --     suggestion.accept()
      --   end
      -- end, { desc = "Open copilot panel", commander = { cat = "copilot" } })
      --
      -- vim.keymap.set({ "n" }, "<leader>cp", function()
      --   panel.open({
      --     ratio = 0.5,
      --     position = "bottom",
      --   })
      -- end, { desc = "Open copilot panel", commander = { cat = "copilot" } })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    -- enabled = false,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  { "AndreM222/copilot-lualine" },
}
