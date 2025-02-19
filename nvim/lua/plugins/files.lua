local c = require("lib.commands")

return {
  {
    "stevearc/oil.nvim",
    opts = {},
    config = function()
      local oil = require("oil")
      oil.setup({
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = function() vim.cmd("noh") end,
          ["<Esc>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.close",
          ["<Backspace>"] = "actions.parent",
          ["_"] = "actions.open_cwd",
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" and Snacks ~= nil then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory", commander = { cat = "oil" } })
      -- Open parent directory in floating window
      vim.keymap.set(
        "n",
        "<leader>-",
        require("oil").toggle_float,
        { desc = "Open parent directory in floating window", commander = { cat = "oil" } }
      )
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    priority = 900,
    version = "*",
    lazy = false,
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })

      vim.keymap.set(
        "n",
        "<leader>F",
        "<CMD>NvimTreeToggle<CR>",
        { desc = "Toggle file tree", commander = { cat = "nvim-tree" } }
      )
    end,
  },
  {
    -- Project file navigation
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        settings = {
          key = function()
            local cwd = vim.loop.cwd() or ""
            -- If cwd starts with /var/home, replace it to start with /home
            if cwd:sub(1, 8) == "/var/home" then
              cwd = "/home" .. cwd:sub(9)
            end
            return cwd
          end,
        },
      })

      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Open harpoon quick menu" })

      c.add_command({
        {
          desc = "Add current file to list",
          cmd = function()
            harpoon:list():add()
          end
        },
      }, { cat = "harpoon" })
    end,
  },
}
