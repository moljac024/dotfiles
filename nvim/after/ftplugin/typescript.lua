vim.keymap.set("n", "<leader>tc", ":TSC<CR>", {
  buffer = 0,
  desc = "Type check project (TSC)",
  -- NOTE: Should this be added here? It will add it to global commander command list
  -- commander = { cat = "typescript" },
})
