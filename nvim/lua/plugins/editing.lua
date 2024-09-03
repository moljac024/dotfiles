vim.g.skip_ts_context_commentstring_module = true

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
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
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          insert          = '<C-g>z',
          insert_line     = 'gC-ggZ',
          normal          = 'gz',
          normal_cur      = 'gZ',
          normal_line     = 'gzz',
          normal_cur_line = 'gZZ',
          visual          = 'gz',
          visual_line     = 'gZ',
          delete          = 'gzd',
          change          = 'gzc',
        }
      })
    end,
  },
  {
    -- Sane commenting for JSX/TSX and other mixed language files
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
    -- Clipboard manager
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  },
  {
    -- Project file navigation
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          key = function()
            local cwd = vim.loop.cwd() or ""
            -- If cwd starts with /var/home, replace it to start with /home
            if cwd:sub(1, 8) == "/var/home" then
              cwd = "/home" .. cwd:sub(9)
            end
            return cwd
          end,
        },
      })

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

      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Add current file to harpoon", commander = {} })
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Open harpoon quick menu" })
      vim.keymap.set("n", "<leader>ht", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true,           -- Auto close tags
          enable_rename = true,          -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          -- ["html"] = {
          --   enable_close = false,
          -- },
        },
      })
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
    opts = {
      enabled_on_save = true,
    },
    init = function()
      local tidy = require("tidy")

      vim.keymap.set("n", "<leader>tt", tidy.toggle, { desc = "(tidy) Toggle" })
      vim.keymap.set("n", "<leader>tr", tidy.run, { desc = "(tidy) Format file" })
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
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Conform will run the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        },
        format_after_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "AckslD/muren.nvim",
    config = function()
      require("muren").setup({})

      vim.keymap.set(
        "n",
        "<leader>r",
        "<CMD>:MurenToggle<CR>",
        { desc = "Toggle muren (search and replace)", commander = {} }
      )
    end,
  },
  {
    -- Pretty quickfix window
    "yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      { "kevinhwang91/promise-async" },
    },
    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      -- Option 2: nvim lsp as LSP client
      -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
          capabilities = capabilities
          -- you can add other fields for setting up lsp server in this table
        })
      end
      require('ufo').setup()
    end
  }
}
