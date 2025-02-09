local completion = import("./completion")
local ai = import("./ai")
local debugging = import("./debugging")
local editing = import("./editing")
local files = import("./files")
local git = import("./git")
local lsp = import("./lsp")
local ui = import("./ui")
local util = import("./util")
local terminal = import("./terminal")
local fennel = import("./fennel")
local webdev = import("./webdev")

return {
  ui,
  files,
  git,
  completion,
  editing,
  debugging,
  lsp,
  terminal,
  util,
  fennel,

  ai,
  webdev,
}
