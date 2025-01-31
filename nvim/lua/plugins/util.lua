return {
  {
    "axkirillov/hbac.nvim",
    config = function()
      local hbac = require("hbac")
      hbac.setup({
        autoclose = true, -- set autoclose to false if you want to close manually
        threshold = 10,   -- hbac will start closing unedited buffers once that number is reached
        close_command = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
        telescope = {},
      })

      pcall(require("telescope").load_extension, "hbac")

      vim.keymap.set("n", "<leader>b", "<CMD>Telescope hbac buffers<CR>", { desc = "Search buffers", commander = {} })
    end,
  },
}
