return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },

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

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc><esc><esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<A-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<A-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<A-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<A-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<A-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

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

      for i = 1, 9 do
        local key = i + 1
        if key == 10 then
          key = 0
        end

        local terminal = Terminal:new({ direction = "float", float_opts = float_opts, on_open = on_terminal_open })
        vim.keymap.set("n", "<leader>t" .. key .. "", function()
          terminal:toggle()
        end, { noremap = true, silent = true, desc = "Toggle terminal " .. i + 1 })
      end

      -- Global keybind to toggle main terminal
      vim.keymap.set({ "n", "i", "v", "x" }, "<A-i>", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true })
      vim.keymap.set({ "n", "i", "v", "x" }, "<leader>t1", function()
        main_terminal:toggle()
      end, { noremap = true, silent = true, desc = "Toggle terminal 1" })

      vim.keymap.set("n", "<A-g>", function()
        lazygit:toggle()
      end, { noremap = true, silent = true })
    end,
  },
}
