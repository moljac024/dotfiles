local vault_path = "My Documents/Notebook"

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown", -- Load when opening a markdown file
    -- event = {
    --   "BufReadPre " .. vim.fn.expand("~") .. "/" .. vault_path .. "/**.md",
    --   "BufNewFile " .. vim.fn.expand("~") .. "/" .. vault_path .. "/**.md",
    -- }, -- Load when opening any markdown file from vault
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local obsidian = require("obsidian")
      obsidian.setup({
        workspaces = {
          {
            name = "personal",
            path = vim.fn.expand("~") .. "/" .. vault_path,
          },
        },

        notes_subdir = "Pages",
        new_notes_location = "notes_subdir",
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "Journal",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y/%Y-%m/%Y-%m-%d",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          -- alias_format = "%B %-d, %Y",
          -- Optional, default tags to add to each new daily note created.
          default_tags = { "daily" },
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          -- template = nil,
        },
        -- Specify how to handle attachments.
        attachments = {
          confirm_img_paste = false,
          -- The default folder to place images in via `:ObsidianPasteImg`.
          -- If this is a relative path it will be interpreted as relative to the vault root.
          -- You can always override this per image by passing a full path to the command instead of just a filename.
          img_folder = "Meta/Attachments",
          -- A function that determines the text to insert in the note when pasting an image.
          -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
          -- This is the default implementation.
          ---@param client obsidian.Client
          ---@param path obsidian.Path the absolute path to the image file
          ---@return string
          img_text_func = function(client, path)
            path = client:vault_relative_path(path) or path
            return string.format("![%s](%s)", path.name, path)
          end,
        },
      })

      vim.keymap.set("n", "<leader>fnn", ":ObsidianNew ", { desc = "Create new note", commander = {} })
      vim.keymap.set("n", "<leader>fna", "<CMD>ObsidianQuickSwitch<CR>", { desc = "Search notes", commander = {} })
      vim.keymap.set(
        "n",
        "<leader>fnd",
        "<CMD>ObsidianDailies -7 1<CR>",
        { desc = "Search daily notes", commander = {} }
      )
    end,
  },
}
