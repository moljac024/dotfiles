return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require('mini.extra').setup()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.icons').setup()
      require('mini.diff').setup()
      require('mini.pick').setup({
        mappings = {
          move_down = '<C-j>',
          move_up   = '<C-k>',
        }
      })

      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })

      local function override_select()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(items, opts, on_choice)
          local start_opts = { window = { config = { width = vim.o.columns } } }
          ---@diagnostic disable-next-line: undefined-global
          return MiniPick.ui_select(items, opts, on_choice, start_opts)
        end
      end

      override_select()

      vim.keymap.set('n', '<leader>f', function()
        MiniPick.builtin.files()
      end, { desc = 'Open file picker', commander = {} })

      vim.keymap.set('n', '<leader>b', function()
        MiniPick.builtin.buffers()
      end, { desc = 'Open buffer picker', commander = {} })

      vim.keymap.set('n', '<leader>/', function()
        MiniPick.builtin.grep_live()
      end, { desc = 'Open global search picker', commander = {} })

      vim.keymap.set('n', '<leader>h', function()
        MiniPick.builtin.help()
      end, { desc = 'Open help picker', commander = {} })

      vim.keymap.set('n', "<leader>'", function()
        MiniPick.builtin.resume()
      end, { desc = 'Open last picker', commander = {} })
    end
  },
}
