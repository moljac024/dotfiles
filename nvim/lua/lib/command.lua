local M = {}

local commands = {}

local function run_command(x)
  if type(x) == "function" then
    x()
  else
    if type(x) == "string" then
      local cmd = vim.api.nvim_replace_termcodes(x, true, false, true)
      vim.api.nvim_feedkeys(cmd, "t", true)
    else
      error("Invalid command type: " .. type(x))
    end
  end
end

M.add_commands = function(cmds)
  commands = vim.list_extend(commands, cmds)
end

M.open_command_picker = function()
  vim.ui.select(commands, {
    prompt = 'Run command',
    format_item = function(item)
      -- If item keys is a non-empty table of keybinds, show those in parens next to desc
      if type(item.keys) == "table" and #item.keys > 0 then
        local keys_strs = {}
        for _, keybind in ipairs(item.keys) do
          if type(keybind) == "table" and #keybind == 2 then
            local mode = keybind[1]

            -- if mode is table, join all elems with comma
            if type(mode) == "table" then
              mode = table.concat(mode, ", ")
            end

            local lhs = keybind[2]
            table.insert(keys_strs, string.format("%s: %s", mode, lhs))
          end
        end
        if #keys_strs > 0 then
          return string.format("%s (%s)", item.desc, table.concat(keys_strs, ", "))
        end
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

    if vim.islist(lhs) then
      -- Loop through all rhs and apply the same opts
      for _, l in ipairs(lhs) do
        patched_keymap_set(modes, l, rhs, opts)
      end

      return
    end

    -- Which key integration
    local has_which_key, which_key = pcall(require, "which-key")
    local should_configure_which_key = has_which_key
        and type(opts.which_key) == "table"
        and type(opts.which_key.keys) == "string"
        and opts.which_key.keys ~= ""

    if should_configure_which_key then
      local original_rhs = rhs
      rhs = function()
        local which_key_show_args = vim.deepcopy(opts.which_key)
        which_key.show(which_key_show_args)

        return original_rhs()
      end
      -- Remove extra keys from opts
      opts.which_key = nil
    end

    -- Add command
    local should_add_command = type(opts.desc) == 'string' and opts.desc ~= "" and type(opts.commander) == "table"

    if should_add_command then
      M.add_commands({
        {
          keys = {
            { modes, lhs },
          },
          desc = opts.desc or "",
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
