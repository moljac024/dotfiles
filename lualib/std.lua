local M = {}

-- =============================================================================
-- ==== String
-- =============================================================================

M.string = {}

M.string.contains = function(self, sub)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:find(sub, 1, true) ~= nil
end

M.string.starts_with = function(self, start)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:sub(1, #start) == start
end
M.string.startsWith = M.string.starts_with

M.string.ends_with = function(self, ending)
  ---@diagnostic disable-next-line: param-type-mismatch
  return ending == "" or self:sub(- #ending) == ending
end
M.string.endsWith = M.string.ends_with

M.string.replace = function(self, old, new)
  local out = self
  local search_start_idx = 1

  while true do
    ---@diagnostic disable-next-line: param-type-mismatch
    local start_idx, end_idx = out:find(old, search_start_idx, true)
    if (not start_idx) then
      break
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local postfix = out:sub(end_idx + 1)
    ---@diagnostic disable-next-line: param-type-mismatch
    out = out:sub(1, (start_idx - 1)) .. new .. postfix

    search_start_idx = -1 * postfix:len()
  end

  return out
end

M.string.insert = function(self, pos, text)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:sub(1, pos - 1) .. text .. self:sub(pos)
end

M.string.split = function(istr, sep)
  local out = {}

  if sep == nil then
    sep = "%s"
  end

  for str in string.gmatch(istr, "([^" .. sep .. "]+)") do
    table.insert(out, str)
  end

  return out
end

-- =============================================================================
-- ==== Table
-- =============================================================================

M.includes = function(t, value)
  for i = 1, #t do
    if (t[i] == value) then
      return true
    end
  end
  return false
end

M.filter = function(t, func)
  local out = {}

  for i = 1, #t do
    if func(t[i]) then
      table.insert(out, t[i])
    end
  end

  return out
end

M.map = function(t, f)
  local out = {}

  for k, v in pairs(t) do
    out[k] = f(v, k)
  end

  return out
end

M.values = function(t)
  local out = {}

  for _, v in pairs(t) do
    table.insert(out, v)
  end

  return out
end

M.concat = function(a1, a2)
  local out = {}

  for i = 1, #a1 do
    out[#out + 1] = a1[i]
  end

  for i = 1, #a2 do
    out[#out + 1] = a2[i]
  end

  return out
end

M.merge = function(t1, t2)
  local out = {}

  for k, v in pairs(t1) do
    out[k] = v
  end

  for k, v in pairs(t2) do
    out[k] = v
  end

  return out
end

M.shuffle = function(t)
  local out = {}

  for i = 1, #t do out[i] = t[i] end
  for i = #t, 2, -1 do
    local j = math.random(i)
    out[i], out[j] = out[j], out[i]
  end

  return out
end

M.take = function(t, n)
  local out = {}

  for i = 1, math.min(n, #t) do
    out[i] = t[i]
  end

  return out
end

return M
