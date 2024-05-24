vim.g.skip_ts_context_commentstring_module = true

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      ---@diagnostic disable-next-line: missing-fields
      configs.setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "elixir",
          "heex",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "sql",
          "css",
          "html",
          "xml",
          "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        ---@diagnostic disable-next-line: unused-local
        disable = function(lang, buf)
          local max_filesize = 200 * 1024 -- Max file size in KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      })
    end,
  },
  -- Sane commenting for JSX/TSX and other mixed language files
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  },
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
          vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap)")

          -- vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)")
          -- vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)")
          return
        end

        -- Show warning about unknown variant
        if variant ~= nil then
          notify("Unknown leap variant: " .. variant)
        end
      end

      activateKeymaps("alternative") -- "default" or "alternative"
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
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
        },
        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}
