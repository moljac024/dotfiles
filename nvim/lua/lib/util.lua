local M = {}

-- Function to copy relative path of current buffer
M.copy_relative_file_path_of_active_buffer = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    print("No file in current buffer")
    return
  end
  local relpath = vim.fn.fnamemodify(filepath, ":.") -- relative to cwd
  vim.fn.setreg("+", relpath)                        -- copy to system clipboard
  print("Copied relative path: " .. relpath)
end

return M
