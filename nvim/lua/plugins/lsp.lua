return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble<cr>",
        desc = "Open trouble",
      },
      {
        "<leader>xc",
        "<cmd>Trouble close<cr>",
        desc = "Close trouble",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",                                -- only load on lua files
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    opts = {
      library = {
        "luvit-meta/library",
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("dropbar").setup()

      vim.keymap.set({ "n" }, "<leader>o", function()
        require("dropbar.api").pick()
      end, { noremap = true, desc = "Pick from dropbar", commander = { cat = "dropbar" } })
    end,
  },

  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          require("hover.providers.dap")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "single",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = false,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
    end,
  },
  {
    "stevearc/aerial.nvim",
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        backends = { "lsp", "treesitter" },
        show_guides = true,
        layout = {
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 20,
        },
        float = {
          -- relative = "editor",
          max_height = 0.9,
        }
      })

      -- vim.keymap.set({ "n" }, "<A-o>", "<CMD>AerialToggle float<CR>", { commander = {} })
    end,
  },
  {
    "hedyhli/outline.nvim",
    -- enabled = false,
    config = function()
      local outline = require("outline")
      outline.setup({
        -- Your setup opts here (leave empty to use defaults)
      })

      local toggle = function()
        -- Fix an issue with stickybuf where calling toggle while focus is in
        -- outline raises an error
        if outline.is_focus_in_outline() then
          outline.focus_toggle()
        end
        -- Sleep for a bit before calling the toggle function. There is a
        -- weird race condition where if it's called too soon after changing
        -- focus an error is raised. It has something to do with stickybuf IMO.
        vim.defer_fn(function()
          outline.toggle()
        end, 200)
      end

      vim.keymap.set(
        { "n", "i", "v", "x" },
        "<A-o>",
        toggle,
        { desc = "Toggle outline", commander = { cat = "outline" } }
      )
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- JSON schemas
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require("lspconfig")

      local servers = {
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        bashls = {},
        lua_ls = {},

        cssls = {},
        tailwindcss = {},
        eslint = {},
        -- tsserver = {} -- Default typescript LSP,
        vtsls = {}, -- Alternative typescript LSP

        pyright = {},
        elixirls = {},
        rust_analyzer = {},
        gopls = {},
        csharp_ls = {},
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        return not t.manual_install
      end, vim.tbl_keys(servers))

      require("mason").setup()
      require("mason-tool-installer").setup({ ensure_installed = servers_to_install })
      require("mason-lspconfig").setup()

      for name, config in pairs(servers) do
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local telescope_builtin = require("telescope.builtin")
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set(
            "n",
            "gd",
            telescope_builtin.lsp_implementations,
            { buffer = 0, desc = "Go to implementation(s)" }
          )
          vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = 0, desc = "Go to reference(s)" })
          vim.keymap.set("n", "gD", telescope_builtin.lsp_definitions, { buffer = 0, desc = "Go to definition(s)" })
          vim.keymap.set(
            "n",
            "gt",
            telescope_builtin.lsp_type_definitions,
            { buffer = 0, desc = "Go to type definition(s)" }
          )

          -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover (LSP)", buffer = 0 })

          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0, desc = "Rename symbol" })
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code actions" })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          require("conform").format({
            bufnr = args.buf,
            lsp_fallback = true,
            quiet = true,
          })
        end,
      })
    end,
  },
}
