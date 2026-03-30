-- ############################################################################
-- ## Navigation
-- ############################################################################

vim.pack.add({
  "https://github.com/folke/flash.nvim",
  "https://github.com/chrisgrieser/nvim-origami",
})

local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })

-- ############################################################################
-- ## Folding
-- ############################################################################

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

require("origami").setup({})

-- ############################################################################
-- ## Render markdown
-- ############################################################################

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})
require('render-markdown').setup({})
