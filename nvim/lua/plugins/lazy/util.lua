return {
  -- Clean up old buffers
  {
    "axkirillov/hbac.nvim",
    config = function()
      local hbac = require("hbac")
      hbac.setup({
        -- set autoclose to false if you want to close manually
        autoclose = true,
        -- hbac will start closing unedited buffers once that number is reached
        threshold = 10,
        close_command = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
        -- hbac will close buffers with associated windows if this option is `true`
        close_buffers_with_windows = false,
      })
    end,
  },
}
