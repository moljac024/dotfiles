local base = import("./base")
local completion = import("./completion")
local editing = import("./editing")
local files = import("./files")
local lsp = import("./lsp")
local ui = import("./ui")
local terminal = import("./terminal")
local dev = import("./dev")
local ai = import("./ai")

return {
  base,
  ui,
  files,
  editing,
  completion,
  terminal,
  dev,
  lsp,
  ai,
}
