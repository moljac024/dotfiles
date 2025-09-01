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
local git = import("./git")

local ai = import("./ai")
local copilot = import("./copilot")

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
  git,

  ai,
  copilot,
}
