return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")
      local float_opts = {
        row = 1,
        col = 7,
        width = function()
          -- return math.ceil(vim.o.columns * 0.90)
          return vim.o.columns - 2
        end,
        height = function()
          -- return math.ceil(vim.o.lines * 0.85)
          return vim.o.lines - 5
        end,
      }
      toggleterm.setup({})

      vim.keymap.set("t", "<C-g>n", [[<C-\><C-n>]], { noremap = true, desc = "Go to normal mode" })
      vim.keymap.set("t", "<C-g>g", [[<C-\><C-g>]],
        { noremap = true, desc = "Send CTRL-G to terminal" })
      vim.keymap.set("t", "<C-g><C-g>", [[<C-\><C-g>]],
        { noremap = true, desc = "Send CTRL-G to terminal" })

      -- Local terminal keybind to toggle
      local on_terminal_open = function(t)
        vim.keymap.set({ "t", "n" }, "<A-i>", function()
          t:toggle()
        end, { noremap = true, silent = true, buffer = 0 })
      end

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(t)
          on_terminal_open(t)
          vim.keymap.set({ "t" }, "<A-g>", "q", { noremap = true, silent = true, buffer = 0 })
          vim.keymap.set({ "n" }, "<A-g>", function()
            t:toggle()
          end, { noremap = true, silent = true, buffer = 0 })
        end,
      })
      local main_terminal = Terminal:new({ direction = "float", float_opts = float_opts, on_open = on_terminal_open })

      -- Global keybind to toggle main terminal
      vim.keymap.set({ "n" }, "<leader>tt", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true, desc = "Toggle main terminal", commander = { cat = "toggleterm" } })
      vim.keymap.set({ "n" }, "<A-i>", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true, desc = "Toggle main terminal" })

      -- Toggle lazygit terminal
      vim.keymap.set("n", "<leader>tg", function()
        lazygit:toggle()
      end, { noremap = true, silent = true, desc = "Toggle lazygit terminal", commander = { cat = "toggleterm" } })
      vim.keymap.set("n", "<A-g>", function()
        lazygit:toggle()
      end, { noremap = true, silent = true, desc = "Toggle lazygit terminal" })
    end,
  },
}
