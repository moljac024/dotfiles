local M = {}
local base = "lib" .. "."

M.std = require(base .. "std")
M.git = require(base .. "git")
M.command = require(base .. "command")
M.util = require(base .. "util")

return M
