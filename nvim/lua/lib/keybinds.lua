local M = {}

-- Monkey patch keymap set so that it supports additional functionality and
-- integration with plugins
M.patch_keymap_set_for_commander = function()
  local vim_keymap_set = vim.keymap.set

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(...)
    local args = { ... }
    local modes = args[1]
    local lhs = args[2]
    local rhs = args[3]
    local opts = args[4] or {}

    -- Which key integration
    local util = require("lib.util")
    local which_key_ok, which_key = pcall(require, "which-key")
    local should_configure_which_key = which_key_ok
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
    local commander_ok, commander = pcall(require, "commander")
    local should_add_to_commander = commander_ok
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

    vim_keymap_set(...)
  end
end

return M
