local M = {}

M.find_tsc_bin = function()
  local node_modules_tsc_binary = vim.fn.findfile("node_modules/.bin/tsc", ".;")

  if node_modules_tsc_binary ~= "" then
    return node_modules_tsc_binary
  end

  return "npx tsc"
end

return M
