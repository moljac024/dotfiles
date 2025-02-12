return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.pairs').setup()
      require('mini.icons').setup()
      require('mini.git').setup()
      require('mini.jump2d').setup() -- Jump to any 2 character location
    end
  },
}
