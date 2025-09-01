local c = require("lib.command")

return {
  {
    "lewis6991/gitsigns.nvim",
    -- enabled = false,
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()

      c.add_commands({
        {
          desc = "Toggle git blame on cursor line",
          cmd = gitsigns.toggle_current_line_blame
        },
        {
          desc = "Open git blame",
          cmd = "<CMD>Gitsigns blame<CR>"
        }
      })
    end,
  },
}
