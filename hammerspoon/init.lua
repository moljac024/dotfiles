-- =============================================================================
-- == Auto reload
-- =============================================================================

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  local should_reload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      should_reload = true
    end
  end
  if should_reload then
    hs.reload()
  end
end):start()

-- =============================================================================
-- == Helper functions
-- =============================================================================

local function safe_bind_key(mods, key, fn)
  local mod_str = table.concat(mods, "+")
  local action = "Assigning"

  if not hs.hotkey.assignable(mods, key) then
    hs.printf("Skipping bind of %s+%s (not assignable)", mod_str, key)
    return nil
  end

  if type(fn) ~= "function" then
    action = "Disabling"
    fn = function() end
  end

  hs.printf("%s %s+%s", action, mod_str, key)
  return hs.hotkey.bind(mods, key, fn)
end

local function lock_screen()
  -- This relies on the existence of an app called Lock Screen. Can be created via Automator.
  -- hs.application.launchOrFocus("Lock Screen.app") -- If you have the Lock Screen.app, can also be made via Automator

  -- This function uses private Apple APIs and could therefore stop working in any given release of macOS without warning.
  hs.caffeinate.lockScreen()
end

-- GNOME mode: cmd+1..0 always "run or raise" apps in your chosen order.
local function gnomify(dock_app_list)
  if type(dock_app_list) ~= "table" then
    hs.printf("warning: gnomify parameter is not a table")
    return
  end

  for i = 1, 10 do
    local key = (i == 10) and "0" or tostring(i)
    safe_bind_key({ "cmd" }, key, function()
      if type(dock_app_list[i]) == "string" then
        hs.application.launchOrFocus(dock_app_list[i])
      end
    end)
  end
end

-- =============================================================================
-- == Main config
-- =============================================================================

gnomify({
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

-- Kill app hiding keybind
safe_bind_key({ "cmd" }, "h", nil)

-- Lock screen keybind
safe_bind_key({ "cmd", "alt" }, "l", lock_screen)
