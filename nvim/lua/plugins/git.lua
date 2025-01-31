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
      local c = require("util/commands")
      gitsigns.setup()

      c.add_command(
        {
          desc = "Toggle git blame for current line",
          cmd = gitsigns.toggle_current_line_blame
        }
      )
    end,
  },
}
