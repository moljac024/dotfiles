local vault_path = os.getenv("NOTEBOOK_PATH")

-- If vault path env is not set, don't activate plugin
if vault_path == nil then
  return {}
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  init = function()
    require("obsidian").setup({
      legacy_commands = false, -- this will be removed in the next major release
      daily_notes = {
        folder = "Journal",
        date_format = "%Y-%m-%d",
      },
      workspaces = {
        {
          name = "personal",
          path = vault_path,
        },
      },
    })
  end
}
