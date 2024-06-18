local vault_path = "My Documents/Notebook"

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown", -- Load when opening a markdown file
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/" .. vault_path .. "/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/" .. vault_path .. "/**.md",
    }, -- Load when opening any markdown file from vault
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = vim.fn.expand("~") .. vault_path,
        },
      },
    },
  },
}
