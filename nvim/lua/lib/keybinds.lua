local util = require("lib.util")

local M = {}

-- Monkey patch keymap set so that it supports additional functionality and
-- integration with plugins
M.patch_keymap_set_for_commander = function()
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
        local which_key_show_args = util.deep_copy_table(opts.which_key)
        which_key.show(which_key_show_args)

        return original_rhs()
      end
      -- Remove extra keys from opts
      opts.which_key = nil
    end

    -- Commander integration
    local has_commander, commander = pcall(require, "commander")
    local should_add_to_commander = has_commander
        and type(opts.desc) == "string"
        and opts.desc ~= ""
        and type(opts.commander) == "table"

    if should_add_to_commander then
      commander.add({
        {
          keys = {
            { modes, lhs },
          },
          desc = opts.desc or "",
          cmd = rhs,
        },
      }, {
        set = false,
        show = true,
        cat = opts.commander.cat,
      })
    end
    -- Remove extra keys from opts
    opts.commander = nil

    original_vim_keymap_set(...)
  end

  vim.keymap.set = patched_keymap_set
end

return M
