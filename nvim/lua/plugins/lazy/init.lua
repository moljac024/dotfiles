local base = require("plugins.lazy.base")
local mini = require("plugins.lazy.mini")
local completion = require("plugins.lazy.completion")
local editing = require("plugins.lazy.editing")
local files = require("plugins.lazy.files")
local util = require("plugins.lazy.util")
local lsp = require("plugins.lazy.lsp")
local ui = require("plugins.lazy.ui")
local terminal = require("plugins.lazy.terminal")
local dev = require("plugins.lazy.dev")
local obsidian = require("plugins.lazy.obsidian")
local ai = require("plugins.lazy.ai")

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
