local std = require "std"
local M = {}

M.setupAutoReload = function()
  hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
    local shouldReload = false
    for _, file in pairs(files) do
      if file:sub(-4) == ".lua" then
        shouldReload = true
      end
    end
    if shouldReload then
      hs.reload()
    end
  end):start()
end

M.bindKey = function(mods, key, fn)
  local modStr = table.concat(mods, "+")
  local action = "Assigning"

  if not hs.hotkey.assignable(mods, key) then
    hs.printf("Skipping bind of %s+%s (not assignable)", modStr, key)
    return nil
  end

  if type(fn) ~= "function" then
    action = "Disabling"
    fn = function() end
  end

  hs.printf("%s %s+%s", action, modStr, key)
  return hs.hotkey.bind(mods, key, fn)
end

-- GNOME mode: cmd+1..0 always "run or raise" apps in your chosen order.
M.gnomify = function(apps)
  if type(apps) ~= "table" then
    hs.printf("warning: gnomify parameter is not a table")
    return
  end

  for i = 1, 10 do
    local key = (i == 10) and "0" or tostring(i)
    M.bindKey({ "cmd" }, key, function()
      if type(apps[i]) == "string" then
        hs.application.launchOrFocus(apps[i])
      end
    end)
  end
end

M.lockScreen = function()
  -- This relies on the existence of an app called Lock Screen. Can be created via Automator.
  -- hs.application.launchOrFocus("Lock Screen.app") -- If you have the Lock Screen.app, can also be made via Automator

  -- This function uses private Apple APIs and could therefore stop working in any given release of macOS without warning.
  hs.caffeinate.lockScreen()
end

M.handleWinWithoutAXEUI = function(win, fn)
  local axApp = hs.axuielement.applicationElement(win:application())
  local enhanced = axApp.AXEnhancedUserInterface
  if enhanced then
    axApp.AXEnhancedUserInterface = false
  end

  fn(win)

  hs.timer.doAfter(hs.window.animationDuration * 2, function()
    axApp.AXEnhancedUserInterface = enhanced
  end)
end

M.isWindowMaximized = function(win)
  local frame = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  return max.x == frame.x and max.y == frame.y and max.w == frame.w and max.h == frame.h
end

M.moveWindow = function(win, direction)
  M.handleWinWithoutAXEUI(win, function()
    local maximized = M.isWindowMaximized(win)
    if direction == "screen-left" then
      win:moveOneScreenEast()
    end
    if direction == "screen-down" then
      win:moveOneScreenSouth()
    end
    if direction == "screen-right" then
      win:moveOneScreenWest()
    end
    if direction == "screen-up" then
      win:moveOneScreenNorth()
    end

    if maximized then
      win:maximize()
    end
  end)
end

local getRunningApplications = function()
  local apps = hs.fnutils.filter(hs.application.runningApplications(), function(app)
    if app:kind() ~= 1 then
      return false
    end

    if app:isHidden() then
      return false
    end

    if app:mainWindow() == nil then
      return false
    end

    if #app:visibleWindows() == 0 then
      return false
    end

    return true
  end)

  return apps
end

local invokeChooser = function(chooser, opts)
  if type(opts) ~= "table" then
    opts = {}
  end

  if opts.theme == "dark" then
    chooser:bgDark(true)
  end

  if opts.theme == "light" then
    chooser:bgDark(false)
  end

  if type(opts.choices) == "table" then
    chooser:choices(opts.choices)
  end

  chooser:show()
end

local makeChooser = function(getChoices, onSelect)
  local chooser = hs.chooser.new(onSelect)
  local invoke = function(opts)
    local choices = getChoices()

    if type(choices) ~= "table" or #choices < 1 then return nil end
    if type(opts) ~= table then opts = {} end

    local finalOpts = std.merge(opts, { choices = choices })

    return invokeChooser(chooser, finalOpts)
  end

  -- Clear query when closed
  chooser:hideCallback(function()
    chooser:query(nil)
  end)

  return chooser, invoke
end

M.makeApplicationChooser = function()
  local onSelect = function(x)
    if x ~= nil then
      hs.application.launchOrFocus(x.path)
    end
  end

  local getChoices = function()
    return std.map(getRunningApplications(), function(x)
      return {
        text = x:name(),
        image = hs.image.iconForFile(x:path()),
        path = x:path(),
      }
    end)
  end

  local chooser, invoke = makeChooser(getChoices, onSelect)
  chooser:placeholderText("Switch to application")

  return {
    chooser = chooser,
    invoke = invoke,
  }
end

M.makeApplicationWindowChooser = function()
  local onSelect = function(x)
    if x == nil then return nil end

    local window = hs.window.get(x.id)
    if window ~= nil then
      window:focus()
    end
  end

  local getChoices = function()
    local win = hs.window.focusedWindow()
    if win == nil then return nil end

    local app = win:application()
    local choices = std.map(app:allWindows(), function(window)
      return {
        text = window:title(),
        image = window:snapshot(),
        id = window:id(),
      }
    end)

    return choices
  end

  local chooser, invoke = makeChooser(getChoices, onSelect)
  chooser:placeholderText("Switch to application window")

  return {
    chooser = chooser,
    invoke = invoke,
  }
end

return M
