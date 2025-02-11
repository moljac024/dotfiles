local M = {}

local function deep_copy_table(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[deep_copy_table(k, s)] = deep_copy_table(v, s) end
  return res
end

M.deep_copy_table = deep_copy_table

return M
