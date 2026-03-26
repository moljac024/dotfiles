-- Run command keybind
vim.keymap.set("n", "<leader><leader>", Lib.command.open_command_picker, { desc = "Run command" })

-- Commands
Lib.command.add_commands({
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
      Lib.util.copy_relative_file_path_of_active_buffer()
    end,
  },
  -- Quit, closing all windows
  {
    desc = "Quit/Exit",
    cmd = "<CMD>qall!<CR>",
  },
})

-- Scratch buffer
Lib.command.add_commands({
  {
    desc = "Toggle scratch buffer",
    cmd = function()
      Snacks.scratch()
    end,
  },
  {
    desc = "Select scratch buffer",
    cmd = function()
      Snacks.scratch.select()
    end,
  },
})

-- Vim pack
Lib.command.add_commands({
  {
    desc = "Update plugins",
    cmd = function()
      vim.pack.update()
    end,
  },
  {
    desc = "Show plugins",
    cmd = function()
      vim.pack.update(nil, { offline = true })
    end,
  },
  {
    desc = "Sync plugins with lock file",
    cmd = function()
      vim.pack.update(nil, { target = 'lockfile' })
    end,
  },
})
