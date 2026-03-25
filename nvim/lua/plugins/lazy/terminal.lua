local AI_AGENT_CMD = "claude"

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")
      local Terminal = require("toggleterm.terminal").Terminal
      toggleterm.setup({})

      vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { noremap = true, desc = "Go to normal mode" })
      -- vim.keymap.set("t", "<C-q><C-q>", [[<C-\><C-q>]],
      --   { noremap = true, desc = "Send CTRL-Q to terminal" })

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

      -- Local terminal keybind to toggle
      local on_terminal_open = function(t)
        vim.keymap.set({ "t", "n" }, "<A-i>", function()
          t:toggle()
        end, { noremap = true, silent = true, buffer = 0 })
      end

      local main_terminal = Terminal:new({ direction = "float", float_opts = float_opts, on_open = on_terminal_open })
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
      local ai_agent = Terminal:new({
        cmd = AI_AGENT_CMD,
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(t)
          on_terminal_open(t)
          vim.keymap.set({ "t" }, "<A-c>", function()
            t:toggle()
          end, { noremap = true, silent = true, buffer = 0 })
          vim.keymap.set({ "n" }, "<A-c>", function()
            t:toggle()
          end, { noremap = true, silent = true, buffer = 0 })
        end,
      })

      -- Global keybind to toggle main terminal
      vim.keymap.set({ "n" }, "<leader>tt", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true, desc = "Toggle main terminal", commander = { cat = "toggleterm" } })
      vim.keymap.set({ "n" }, "<A-i>", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true, desc = "Toggle main terminal" })

      -- Global keybind to toggle lazygit terminal
      vim.keymap.set("n", "<leader>tg", function()
        lazygit:toggle()
      end, { noremap = true, silent = true, desc = "Toggle lazygit terminal", commander = { cat = "toggleterm" } })
      vim.keymap.set("n", "<A-g>", function()
        lazygit:toggle()
      end, { noremap = true, silent = true, desc = "Toggle lazygit terminal" })

      -- Global keybind to toggle ai agent terminal
      vim.keymap.set("n", "<leader>ta", function()
        ai_agent:toggle()
      end, { noremap = true, silent = true, desc = "Toggle AI terminal", commander = { cat = "toggleterm" } })
      vim.keymap.set("n", "<A-c>", function()
        ai_agent:toggle()
      end, { noremap = true, silent = true, desc = "Toggle AI terminal" })
    end,
  },
}
