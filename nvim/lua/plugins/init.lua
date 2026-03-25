local base = require("plugins.base")
local mini = require("plugins.mini")
local completion = require("plugins.completion")
local editing = require("plugins.editing")
local files = require("plugins.files")
local util = require("plugins.util")
local lsp = require("plugins.lsp")
local ui = require("plugins.ui")
local terminal = require("plugins.terminal")
local dev = require("plugins.dev")
local obsidian = require("plugins.obsidian")
local ai = require("plugins.ai")

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
  obsidian,
  -- ai,
}
