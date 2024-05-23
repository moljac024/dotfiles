return {
  {
    "kndndrj/nvim-dbee",
    enabled = function()
      -- Disable if running in vscode
      return not vim.g.vscode
    end,
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      require("dbee").install()
    end,
    config = function()
      local source = require("dbee.sources")
      require("dbee").setup({
        sources = {
          source.MemorySource:new({
            ---@diagnostic disable-next-line: missing-fields
            {
              type = "postgres",
              name = "pg-local",
              url = "postgresql://postgres:admin@localhost:5432/mc",
            },
          }, "mc"),
        },
      })

      vim.keymap.set("n", "<leader>od", function()
        require("dbee").open()
      end)

      ---@diagnostic disable-next-line: param-type-mismatch
      local base = vim.fs.joinpath(vim.fn.stdpath("state"), "dbee", "notes")
      local pattern = string.format("%s/.*", base)

      vim.filetype.add({
        extension = {
          sql = function(path, _)
            if path:match(pattern) then
              return "sql.dbee"
            end

            return "sql"
          end,
        },

        pattern = {
          [pattern] = "sql.dbee",
        },
      })
    end,
  },
}
