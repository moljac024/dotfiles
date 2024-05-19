return {
  {
    "ThePrimeagen/harpoon",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
  {
    "m4xshen/autoclose.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    config = function()
      require("autoclose").setup()
    end,
  },
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      local notify = vim.notify

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
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
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
