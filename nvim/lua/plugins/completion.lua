return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
    },
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }
      vim.opt.shortmess:append("c")

      local lspkind = require("lspkind")
      lspkind.init({})

      local cmp = require("cmp")

      ---@diagnostic disable-next-line: unused-local
      local down_mapping = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.complete()
        end
      end, { "i", "c" })

      local up_mapping = cmp.mapping(function(fallback)
        local function selectPrev()
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        end

        if cmp.visible() then
          selectPrev()
        else
          fallback()
        end
      end, { "i", "c" })

      local accept_mapping = cmp.mapping(function(fallback)
        if cmp.visible() then
          local selected = cmp.get_selected_entry()
          if selected ~= nil then
            return cmp.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = false,
            })
          end
        end
        -- If we got here, fallback
        fallback()
      end, { "i", "c" })

      cmp.setup({
        completion = {
          -- autocomplete = false, -- Only trigger completion when explicitly called
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            },
          }),
        },
        sources = {
          { name = "copilot",  group_index = 1 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "buffer",   group_index = 2 },
          { name = "path",     group_index = 2 },
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = down_mapping,
          ["<C-p>"] = up_mapping,
          ["<C-j>"] = down_mapping,
          ["<C-k>"] = up_mapping,
          ["<CR>"] = accept_mapping,
          ["<C-CR>"] = accept_mapping,
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s" }),
          ["<Tab>"] = down_mapping,
          ["<S-Tab>"] = up_mapping,
        },
      })

      -- Command line completions
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' }
              }
            }
          }
        )
      })

      -- Disable copilot panel when nvim-cmp menu is opened
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)
      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },
}
