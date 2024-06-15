return {
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
    end,
    commander = {
      {
        cmd = "<CMD>GitBlameToggle<CR>",
        desc = "Toggle git blame",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()

      vim.keymap.set(
        { "n" },
        "<leader>gb",
        gitsigns.toggle_current_line_blame,
        { desc = "(gitsigns) Toggle git blame for current line", commander = {} }
      )
    end,
  },
}
