local base = import("./base")
local mini = import("./mini")
local completion = import("./completion")
local editing = import("./editing")
local files = import("./files")
local util = import("./util")
local lsp = import("./lsp")
local ui = import("./ui")
local terminal = import("./terminal")
local dev = import("./dev")

local ai = import("./ai")

return {
  base,
  mini,
  completion,
  editing,
  files,
  util,
  lsp,
  ui,
  terminal,
  dev,

  ai,
}
