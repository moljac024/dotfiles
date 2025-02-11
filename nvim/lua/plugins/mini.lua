return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.pairs').setup()
      require('mini.icons').setup()

      -- Git
      -- require('mini.git').setup()
      -- require('mini.diff').setup()

      -- Jump to any 2 characters
      require('mini.jump2d').setup()

      -- Notifications
      require('mini.notify').setup({
        window = {
          winblend = 0
        }
      })
      -- Make mini.notify the default notification handler
      -- vim.notify = require('mini.notify').make_notify()
    end
  },
}
