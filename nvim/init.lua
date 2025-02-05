-- ############################################################################
-- Setup
-- ############################################################################

-- Monkey patch vim's keybind.set so that it supports integration with commander
local keybinds_util = require("util.keybinds")
keybinds_util.patch_keymap_set_for_commander()

-- ############################################################################
-- Config
-- ############################################################################

if not vim.g.vscode then
  require("config")
else
  require("vscode.config")
end

-- ############################################################################
-- Lazy (plugin manager)
-- ############################################################################

local lazy = require("util.lazy")
lazy.init()

-- ############################################################################
-- Keybindings
-- ############################################################################

if not vim.g.vscode then
  require("config.keybinds")
end
