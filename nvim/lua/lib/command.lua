local util = import("./util")

local M = {}

local commands = {}

local function run_command(x)
  if type(x) == "function" then
    x()
  elseif type(x) == "string" then
    local cmd = vim.api.nvim_replace_termcodes(x, true, false, true)
    vim.api.nvim_feedkeys(cmd, "t", true)
  else
    error("Invalid command type: " .. type(x))
  end
end

local function get_command_keys(item)
  -- If item keys is a non-empty table of keybinds, show those in parens next to desc
  if type(item.keys) == "table" and #item.keys > 0 then
    local keys_strs = {}
    for _, keybind in ipairs(item.keys) do
      if type(keybind) == "table" and #keybind == 2 then
        local mode = keybind[1]
        if type(mode) == "table" then
          mode = table.concat(mode, ", ")
        end

        local lhs = keybind[2]
        table.insert(keys_strs, string.format("[%s] %s", mode, lhs))
      end
    end

    if #keys_strs > 0 then
      return table.concat(keys_strs, " | ")
    end

    return nil
  end
end

M.add_commands = function(cmds)
  for _, item in ipairs(cmds) do
    local existing_index = util.find_index(commands, function(c)
      return c.desc == item.desc
    end)

    if (existing_index ~= -1) then
      local existing_item = commands[existing_index]
      -- Merge keys
      if type(item.keys) == "table" and #item.keys > 0 then
        if type(existing_item.keys) ~= "table" then
          existing_item.keys = {}
        end
        for _, keybind in ipairs(item.keys) do
          if not util.includes(existing_item.keys, keybind) then
            table.insert(existing_item.keys, keybind)
          end
        end
      end
    else
      table.insert(commands, item)
    end
  end
end

M.open_command_picker = function()
  vim.ui.select(commands, {
    prompt = 'Run command',
    format_item = function(item)
      local keys = get_command_keys(item)
      if keys ~= nil then
        return string.format("%s (%s)", item.desc, keys)
      end

      return item.desc
    end,
  }, function(item)
    if (item == nil) then
      return
    end

    run_command(item.cmd)
  end)
end

-- Monkey patch keymap set so that it supports additional functionality and
-- integration with plugins
M.patch_keymap_set = function()
  local original_vim_keymap_set = vim.keymap.set

  local function patched_keymap_set(...)
    local args = { ... }
    local modes = args[1]
    local lhs = args[2]
    local rhs = args[3]
    local opts = args[4] or {}

    -- Should add command?
    local should_add_command =
        type(opts.desc) == 'string'
        and opts.desc ~= ""
        and type(opts.commander) == "table"

    -- Add command
    if should_add_command then
      M.add_commands({
        {
          keys = {
            { modes, lhs },
          },
          desc = opts.desc,
          cmd = rhs,
        },
      })
    end
    -- Remove extra keys from opts
    opts.commander = nil

    original_vim_keymap_set(...)
  end

  vim.keymap.set = patched_keymap_set
end

return M
