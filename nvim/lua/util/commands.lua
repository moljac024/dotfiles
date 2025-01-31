local M = {}

M.add_command = function(...)
  local args = { ... }
  local cmds = args[1] or {}
  local props = args[2] or {}
  local commander_ok, commander = pcall(require, "commander")

  if not commander_ok then
    return
  end

  -- Commander is installed
  commander.add(
    cmds,
    {
      set = false,
      show = true,
      cat = props.cat
    })
end

return M
