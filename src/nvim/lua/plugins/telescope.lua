return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local data = assert(vim.fn.stdpath("data")) --[[@as string]]

      require("telescope").setup({
        extensions = {
          fzf = {},
          wrap_results = true,
          history = {
            path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
            limit = 100,
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)

      vim.keymap.set("n", "<leader>gw", builtin.grep_string)

      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
    end,
  },
}
