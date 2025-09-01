return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
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
    "lewis6991/hover.nvim",
    config = function()
      local hover = require("hover")

      hover.setup({
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
      vim.keymap.set("n", "K", function()
        -- No op
      end)
      vim.keymap.set("n", { "<leader>k", "K" }, hover.hover, { desc = "Show docs for item under cursor (hover)" })
    end,
  },
  { 'kosayoda/nvim-lightbulb' },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
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
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
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
        rust_analyzer = {},
        gopls = {},
        fennel_ls = {
          manual_install = true
        }
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        local should_install = not t.manual_install
        t.should_install = nil
        return should_install
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
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          if MiniExtra ~= nil then
            -- Go to implementation
            vim.keymap.set(
              "n",
              "gi", function()
                MiniExtra.pickers.lsp({ scope = 'implementation' })
              end,
              { buffer = 0, desc = "Go to implementation" })
            -- Go to definition(s)
            vim.keymap.set(
              "n",
              "gd", function()
                MiniExtra.pickers.lsp({ scope = 'definition' })
              end,
              { buffer = 0, desc = "Go to definition(s)" })
            -- Go to type definition
            vim.keymap.set(
              "n",
              "gd", function()
                MiniExtra.pickers.lsp({ scope = 'type_definition' })
              end,
              { buffer = 0, desc = "Go to type definition" })
            -- Go to references
            vim.keymap.set(
              "n",
              "gr", function()
                MiniExtra.pickers.lsp({ scope = 'references' })
              end,
              { buffer = 0, desc = "Go to definition(s)" })
          end

          local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
          if has_telescope then
            vim.keymap.set(
              "n",
              "gi",
              telescope_builtin.lsp_implementations,
              { buffer = 0, desc = "Go to implementation(s)" }
            )
            vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = 0, desc = "Go to reference(s)" })
            vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { buffer = 0, desc = "Go to definition(s)" })
            vim.keymap.set(
              "n",
              "gt",
              telescope_builtin.lsp_type_definitions,
              { buffer = 0, desc = "Go to type definition(s)" }
            )

            vim.keymap.set("n", "<leader>d", telescope_builtin.diagnostics,
              { buffer = 0, desc = "Open diagnostics", })
          end

          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename symbol" })
          vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { buffer = 0, desc = "Code actions" })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      local has_conform, conform = pcall(require, "conform")
      if has_conform then
        vim.api.nvim_create_autocmd("BufWritePre", {
          callback = function(args)
            conform.format({
              bufnr = args.buf,
              lsp_fallback = true,
              quiet = true,
            })
          end,
        })
      end
    end,
  },
}
