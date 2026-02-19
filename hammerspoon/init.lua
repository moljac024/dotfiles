-- =============================================================================
-- == Setup
-- =============================================================================

local lib = require "lib"

lib.setupAutoReload()
-- hs.window.animationDuration = 0

-- =============================================================================
-- == Main config
-- =============================================================================

lib.gnomify({
  "Finder", -- Has to be in first slot
  "Ghostty.app",
  "Microsoft Edge.app",
  "Firefox.app",

  -- "Visual Studio Code.app",
  "Windsurf.app",
  "DBeaver.app",

  "Obsidian.app",

  "Microsoft Teams.app",
  "Microsoft Outlook.app",
  -- "Microsoft OneNote.app",
  "Microsoft 365 Copilot.app",

  "Excalidraw.app"
})

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

-- Kill app hiding keybinds
lib.bindKey({ "cmd" }, "h", nil)
lib.bindKey({ "cmd", "alt" }, "h", nil)

-- Lock screen keybind
lib.bindKey({ "cmd", "ctrl", "alt" }, "l", lib.lockScreen)

lib.bindKey({ "cmd" }, "'", lib.applicationChooser.invoke)
