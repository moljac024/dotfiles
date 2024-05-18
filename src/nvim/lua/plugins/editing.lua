return {
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      local notify = require("notify")

      -- Disable auto-jumping to the first match
      leap.opts.safe_labels = {}

      leap.opts.equivalence_classes = {
        "aá",
        "eé",
        "ií",
        "sš",
        "cć",
        "cč",
      }

      local function activateKeymaps(variant)
        if variant == "default" then
          vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
          vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
          vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")

          return
        end

        if variant == "alternative" then
          vim.keymap.set("n", "s", "<Plug>(leap)")
          vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
          vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
          vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")

          return
        end

        -- Show warning about unknown variant
        if variant ~= nil then
          notify("Unknown leap variant: " .. variant)
        end
      end

      -- activateKeymaps()
      activateKeymaps("default")
    end,
  },
  {
    "mcauley-penney/tidy.nvim",
    opts = {
      enabled_on_save = true,
    },
    init = function()
      local tidy = require("tidy")

      vim.keymap.set("n", "<leader>tt", tidy.toggle, {})
      vim.keymap.set("n", "<leader>tr", tidy.run, {})
    end,
  },
}
