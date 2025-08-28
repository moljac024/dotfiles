local c = require("lib.command")
local util = require("lib.util")

c.add_command({
  {
    desc = "Copy current file path",
    cmd = function()
      util.copy_relative_file_path_of_active_buffer()
    end,
  },
})
