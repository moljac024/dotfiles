local c = require("lib.command")

-- Function to copy relative path of current buffer
local function copy_relative_file_path_of_active_buffer()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    print("No file in current buffer")
    return
  end
  local relpath = vim.fn.fnamemodify(filepath, ":.") -- relative to cwd
  vim.fn.setreg("+", relpath)                        -- copy to system clipboard
  print("Copied relative path: " .. relpath)
end

-- Run command keybind
vim.keymap.set("n", "<leader><leader>", c.open_command_picker, { desc = "Run command" })

-- Commands
c.add_commands({
  -- Buffers
  {
    desc = "Kill current buffer",
    -- cmd = "<CMD>bw<CR>",
    cmd = function()
      Snacks.bufdelete()
    end,
  },
  {
    desc = "Kill current buffer (force)",
    -- cmd = "<CMD>bw!<CR>",
    cmd = function()
      Snacks.bufdelete({ force = true })
    end,
  },
  {
    desc = "Save current buffer",
    cmd = "<CMD>w<CR>"
  },
  {
    desc = "Save all buffers",
    cmd = "<CMD>wa<CR>"
  },
  {
    desc = "Refresh current buffer",
    cmd = "<CMD>e<CR>"
  },
  {
    desc = "Refresh current buffer (force)",
    cmd = "<CMD>e!<CR>"
  },
  -- Util
  {
    desc = "Copy current file path to clipboard (relative)",
    cmd = function()
      copy_relative_file_path_of_active_buffer()
    end,
  },
  -- Quit, closing all windows
  {
    desc = "Quit/Exit",
    cmd = "<CMD>qall!<CR>",
  },
})
