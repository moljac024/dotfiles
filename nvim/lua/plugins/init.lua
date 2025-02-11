local completion = import("./completion")
local editing = import("./editing")
local files = import("./files")
local git = import("./git")
local lsp = import("./lsp")
local ui = import("./ui")
local util = import("./util")
local mini = import("./mini")
local terminal = import("./terminal")
local dev = import("./dev")
local ai = import("./ai")

return {
  ui,
  util,
  files,
  git,
  completion,
  editing,
  terminal,
  mini,
  dev,
  lsp,
  ai,
}
