local base = import("./base")
local completion = import("./completion")
local editing = import("./editing")
local notes = import("./notes")
local files = import("./files")
local util = import("./util")
local lsp = import("./lsp")
local ui = import("./ui")
local terminal = import("./terminal")
local dev = import("./dev")

local ai = import("./ai")
local copilot = import("./copilot")

return {
  base,
  completion,
  editing,
  notes,
  files,
  util,
  lsp,
  ui,
  terminal,
  dev,

  ai,
  copilot,
}
