-- =============================================================================
-- == Setup
-- =============================================================================

local lib = require "lib"

lib.setupAutoReload() -- Auto reload on lua file changes

-- hs.window.animationDuration = 0

-- =============================================================================
-- == Main config
-- =============================================================================

local apps = {
  "Finder", -- Has to be in first slot
  "Ghostty",
  "Microsoft Edge",

  -- "Visual Studio Code",
  "Windsurf",

  "DBeaver",
  "Obsidian",

  "Microsoft Teams",
  "Microsoft Outlook",
  "Microsoft 365 Copilot",

  "Excalidraw"
}

lib.gnomify(apps)

-- Window management
lib.bindKey({ "cmd", "alt" }, "h", function() lib.moveWindow(hs.window.focusedWindow(), "screen-left") end)
lib.bindKey({ "cmd", "alt" }, "j", function() lib.moveWindow(hs.window.focusedWindow(), "screen-down") end)
lib.bindKey({ "cmd", "alt" }, "k", function() lib.moveWindow(hs.window.focusedWindow(), "screen-up") end)
lib.bindKey({ "cmd", "alt" }, "l", function() lib.moveWindow(hs.window.focusedWindow(), "screen-right") end)

lib.bindKey({ "cmd", "alt" }, "up", function()
  lib.handleWinWithoutAXEUI(hs.window.focusedWindow(), function(win)
    win:maximize()
  end)
end)

-- Kill hiding keybinds
lib.bindKey({ "cmd" }, "h", nil)
lib.bindKey({ "cmd", "alt" }, "h", nil)

-- Lock screen keybind
lib.bindKey({ "cmd", "ctrl", "alt" }, "l", lib.lockScreen)

--lication and window choosers
-- locallicationChooser = lib.makeRunningApplicationChooser()
-- local windowChooser = lib.makeFocuselicationWindowChooser()
-- lib.bindKey({ "cmd" }, ";", function()licationChooser.invoke({}) end)
-- lib.bindKey({ "cmd" }, "'", function() windowChooser.invoke({}) end)
