local M = {}

-- =============================================================================
-- ==== String
-- =============================================================================

M.string = {}

M.string.contains = function(str, sub)
  return str:find(sub, 1, true) ~= nil
end

M.string.startswith = function(str, start)
  return str:sub(1, #start) == start
end
M.string.starts_with = M.string.startswith
M.string.startsWith = M.string.startswith

M.string.endswith = function(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end
M.string.ends_with = M.string.endswith
M.string.endsWith = M.string.endswith

M.string.replace = function(str, old, new)
  local out = str
  local search_start_idx = 1

  while true do
    local start_idx, end_idx = out:find(old, search_start_idx, true)
    if (not start_idx) then
      break
    end

    local postfix = out:sub(end_idx + 1)
    out = out:sub(1, (start_idx - 1)) .. new .. postfix

    search_start_idx = -1 * postfix:len()
  end

  return out
end

M.string.insert = function(str, pos, text)
  return str:sub(1, pos - 1) .. text .. str:sub(pos)
end

M.string.split = function(str, sep)
  local out = {}

  if sep == nil then
    sep = "%s"
  end

  for part in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(out, part)
  end

  return out
end

-- =============================================================================
-- ==== Table
-- =============================================================================

M.findindex = function(t, matcher)
  for i = 1, #t do
    if (matcher(t[i])) then
      return i
    end
  end

  return -1
end
M.find_index = M.findindex
M.findIndex = M.findindex

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
