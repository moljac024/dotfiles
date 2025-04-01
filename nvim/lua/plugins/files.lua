local c = require("lib.command")

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
    version = "*",
    lazy = false,
    config = function()
      local function on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local function edit_or_open()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file
            api.node.open.edit()
            -- Close the tree if file was opened
            api.tree.close()
          end
        end

        -- open as vsplit on current node
        local function vsplit_preview()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file as vsplit
            api.node.open.vertical()
          end

          -- Finally refocus on tree if it was lost
          api.tree.focus()
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close parent"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
      end


      require("nvim-tree").setup({
        on_attach = on_attach
      })

      vim.keymap.set(
        "n",
        "<C-h>",
        ":NvimTreeToggle<cr>",
        { silent = true, noremap = true }
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
