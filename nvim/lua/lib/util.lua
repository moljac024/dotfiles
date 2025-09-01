local M = {}

M.patch_string_fns = function()
  function string:contains(sub)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self:find(sub, 1, true) ~= nil
  end

  function string:startswith(start)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self:sub(1, #start) == start
  end

  function string:endswith(ending)
    ---@diagnostic disable-next-line: param-type-mismatch
    return ending == "" or self:sub(- #ending) == ending
  end

  function string:replace(old, new)
    local s = self
    local search_start_idx = 1

    while true do
      ---@diagnostic disable-next-line: param-type-mismatch
      local start_idx, end_idx = s:find(old, search_start_idx, true)
      if (not start_idx) then
        break
      end

      ---@diagnostic disable-next-line: param-type-mismatch
      local postfix = s:sub(end_idx + 1)
      ---@diagnostic disable-next-line: param-type-mismatch
      s = s:sub(1, (start_idx - 1)) .. new .. postfix

      search_start_idx = -1 * postfix:len()
    end

    return s
  end

  function string:insert(pos, text)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self:sub(1, pos - 1) .. text .. self:sub(pos)
  end
end

M.split_str = function(input_str, sep)
  local out = {}

  if sep == nil then
    sep = "%s"
  end

  for str in string.gmatch(input_str, "([^" .. sep .. "]+)") do
    table.insert(out, str)
  end

  return out
end

M.find_index = function(t, matcher)
  for i = 1, #t do
    if (matcher(t[i])) then
      return i
    end
  end

  return -1
end

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

M.shuffle = function(t)
  local out = {}
  for i = 1, #t do out[i] = t[i] end
  for i = #t, 2, -1 do
    local j = math.random(i)
    out[i], out[j] = out[j], out[i]
  end
  return out
end

-- Take the first n entries from table or the whole table if n is larger than
-- the length
M.take = function(t, n)
  local out = {}
  for i = 1, math.min(n, #t) do
    out[i] = t[i]
  end

  return out
end

return M
