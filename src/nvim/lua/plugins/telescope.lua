return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
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
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "smart_history")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      -- local themes = require("telescope.themes")

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)

      vim.keymap.set("n", "<leader>gw", builtin.grep_string)

      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
    end,
  },
}
