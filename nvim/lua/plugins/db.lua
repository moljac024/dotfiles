return {
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      local dbee = require("dbee")
      dbee.setup()

      vim.keymap.set("n", "<leader>dbo", function()
        dbee.open()
      end, { noremap = true, desc = "Open DBee", commander = {} })

      vim.keymap.set("n", "<leader>dbc", function()
        dbee.open()
      end, { noremap = true, desc = "Close DBee", commander = {} })

      vim.keymap.set("n", "<leader>dbt", function()
        dbee.open()
      end, { noremap = true, desc = "Toggle DBee", commander = {} })
    end,
  },
}
