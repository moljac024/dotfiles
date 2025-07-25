-- ############################################################################
-- Setup
-- ############################################################################

-- Allow relative imports
require("lib.import")

-- Monkey patch vim's keybind.set so that it supports integration with commander
require("lib.command").patch_keymap_set_for_commander()

-- ############################################################################
-- Config
-- ############################################################################

require("config.main")

-- ############################################################################
-- Lazy (plugin manager)
-- ############################################################################

require("lib.lazy").init()

-- ############################################################################
-- Keybindings
-- ############################################################################

-- We require keybinds last so that we can reference plugins and to make sure
-- plugins don't override any of our custom keybinds.

require("config.keybinds")
