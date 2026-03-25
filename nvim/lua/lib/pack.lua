local M = {}

local function on_pack_change(name, kind, fn)
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      if ev.data.spec.name == name and ev.data.kind == kind then
        if not ev.data.active then vim.cmd.packadd(name) end
        fn()
      end
    end
  })
end

M.on_pack_install = function(name, fn)
  return on_pack_change(name, "install", fn)
end

M.on_pack_update = function(name, fn)
  return on_pack_change(name, "update", fn)
end

M.on_pack_delete = function(name, fn)
  return on_pack_change(name, "delete", fn)
end

return M
