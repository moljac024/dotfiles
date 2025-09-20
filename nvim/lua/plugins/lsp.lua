return {
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
  { 'kosayoda/nvim-lightbulb' },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- LSP tool installer
      "b0o/SchemaStore.nvim",    -- JSON and YAML schemas
    },
    config = function()
      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local configs = {
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

        -- tsserver = {} -- Default typescript LSP,
        vtsls = {}, -- Alternative typescript LSP
        cssls = {},
        tailwindcss = {},
        eslint = {},

        pyright = {},
        rust_analyzer = {},
        gopls = {},
      }

      -- Setup mason
      require("mason").setup()
      local registry = require("mason-registry")

      local tools_to_install = {
        "bash-language-server",
        "lua-language-server",

        "rust-analyzer",
        "pyright", -- Python

        "elixir-ls",
        "gopls",

        -- Web
        "json-lsp",
        "yaml-language-server",
        "css-lsp",
        "eslint-lsp",
        "tailwindcss-language-server",
        "vtsls", -- Typescript
      }

      for _, tool in ipairs(tools_to_install) do
        if not registry.is_installed(tool) then
          registry.get_package(tool):install()
        end
      end
      -- End mason setup

      for name, config in pairs(configs) do
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid lsp client")
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
              "gt", function()
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
            -- Open diagnostics picker
            vim.keymap.set("n", "<leader>d", function()
                MiniExtra.pickers.diagnostic()
              end,
              { buffer = 0, desc = "Open diagnostics picker", })
          end

          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0, desc = "Rename symbol" })
          vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { buffer = 0, desc = "Code actions" })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Conform integration
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
