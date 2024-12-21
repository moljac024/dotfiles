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
