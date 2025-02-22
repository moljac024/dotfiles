local wezterm = require("wezterm") -- Pull in the wezterm API
local io = require('io')
local os = require('os')

local mux = wezterm.mux
local config = wezterm.config_builder() -- This will hold the configuration.
local act = wezterm.action
local global = wezterm.GLOBAL

---@diagnostic disable-next-line: unused-local
local log = {
  info = wezterm.log_info,
  warn = wezterm.log_warn,
  error = wezterm.log_error
}

-- =============================================================================
-- ==== Functions
-- =============================================================================
--
function string:contains(sub)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:find(sub, 1, true) ~= nil
end

function string:startswith(start)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:sub(1, #start) == start
end

function string:endswith(ending)
  ---@diagnostic disable-next-line: param-type-mismatch
  return ending == "" or self:sub(- #ending) == ending
end

function string:replace(old, new)
  local s = self
  local search_start_idx = 1

  while true do
    ---@diagnostic disable-next-line: param-type-mismatch
    local start_idx, end_idx = s:find(old, search_start_idx, true)
    if (not start_idx) then
      break
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local postfix = s:sub(end_idx + 1)
    ---@diagnostic disable-next-line: param-type-mismatch
    s = s:sub(1, (start_idx - 1)) .. new .. postfix

    search_start_idx = -1 * postfix:len()
  end

  return s
end

function string:insert(pos, text)
  ---@diagnostic disable-next-line: param-type-mismatch
  return self:sub(1, pos - 1) .. text .. self:sub(pos)
end

-- Function to check if program is available
---@diagnostic disable-next-line: unused-function, unused-local
local function is_program_available(program)
  local success, stdout, stderr = wezterm.run_child_process({ "which", program })

  log.info(string.format("%s check: success=%s, stdout='%s', stderr='%s'", program, tostring(success), stdout, stderr))
  return success
end

local function split_str(input_str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(input_str, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

---@diagnostic disable-next-line: unused-function, unused-local
local function includes(table, value)
  for i = 1, #table do
    if (table[i] == value) then
      return true
    end
  end
  return false
end


local function filter(t, func)
  local out = {}
  for i = 1, #t do
    if func(t[i]) then
      table.insert(out, t[i])
    end
  end
  return out
end

local function array_concat(a1, a2)
  local t = {}

  for i = 1, #a1 do
    t[#t + 1] = a1[i]
  end

  for i = 1, #a2 do
    t[#t + 1] = a2[i]
  end

  return t
end

local function shuffle(t)
  local s = {}
  for i = 1, #t do s[i] = t[i] end
  for i = #t, 2, -1 do
    local j = math.random(i)
    s[i], s[j] = s[j], s[i]
  end
  return s
end


-- Take the first n entries from table or the whole table if n is larger than
-- the length
local function take(t, n)
  local s = {}
  for i = 1, math.min(n, #t) do
    s[i] = t[i]
  end

  return s
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  -- Possible values are "Light", "Dark"
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Frappe"
  else
    -- return "Catppuccin Latte"
    return "Catppuccin Frappe"
  end
end

local function get_images_from_dir(dir)
  return filter(wezterm.read_dir(dir), function(file)
    return file:endswith(".jpg") or file:endswith(".jpeg") or file:endswith(".png")
  end)
end

local function get_background_images(opts)
  local base_images_dir = wezterm.home_dir .. "/dotfiles/backgrounds/terminal"
  local images = {}

  if (opts and opts.include_simple) then
    images = array_concat(images, get_images_from_dir(base_images_dir .. "/simple"))
  end

  if (opts and opts.include_main) then
    images = array_concat(images, get_images_from_dir(base_images_dir .. "/main"))
  end

  if (opts and opts.include_sketchy) then
    images = array_concat(images, get_images_from_dir(base_images_dir .. "/sketchy"))
  end

  if (opts and opts.include_secret) then
    images = array_concat(images, get_images_from_dir(base_images_dir .. "/secret"))
  end

  return images
end

local function get_random_image(image_pool)
  local tries = 0
  local new_image = image_pool[math.random(#image_pool)]

  while (new_image == global.background_image and tries < 10) do
    new_image = image_pool[math.random(#image_pool)]
    tries = tries + 1
  end

  return new_image
end

local function set_background_image()
  local image = global.background_image
  if image == nil then
    return
  end

  local color_scheme_name = scheme_for_appearance(get_appearance())
  local color_scheme = wezterm.get_builtin_color_schemes()[color_scheme_name]
  local bg_color = wezterm.color.parse(color_scheme.background)

  config.background = {
    { source = { Color = bg_color }, width = '100%', height = '100%' },
    {
      source = {
        File = image
      },
      horizontal_align = "Right",
      vertical_align = "Bottom",
      opacity = 0.15,
      hsb = { brightness = 0.5 }
    },
  }
end

local function make_background_image_chooser(image_opts, opts)
  local function get_choices()
    opts = opts or {}
    local choices = {}
    local images = get_background_images(image_opts)

    if (#images == 0) then
      return
    end

    local shuffled = shuffle(images)
    local limited = take(shuffled, opts.max or 5)

    ---@diagnostic disable-next-line: unused-local
    for i, image in ipairs(limited) do
      local split = split_str(image, "/")
      table.insert(choices, { label = split[#split], id = image })
    end

    return choices
  end

  local function action(window, pane)
    window:perform_action(
      act.InputSelector {
        ---@diagnostic disable-next-line: unused-local
        action = wezterm.action_callback(function(_window, _pane, id, label)
          if not id and not label then
            return
          else
            global.background_image = id
            wezterm.reload_configuration()
          end
        end),
        title = 'Choose background image',
        choices = get_choices(),
      },
      pane
    )
  end

  return wezterm.action_callback(action)
end


local function get_tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return " " .. title .. " "
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return " " .. tab_info.active_pane.title .. " "
end

local rename_tab_action = act.PromptInputLine {
  description = 'Enter new name for tab',
  ---@diagnostic disable-next-line: unused-local
  action = wezterm.action_callback(function(window, pane, line)
    -- line will be `nil` if they hit escape without entering anything
    -- An empty string if they just hit enter
    -- Or the actual line of text they wrote
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

-- =============================================================================
-- ==== Appearance
-- =============================================================================

-- config.font = wezterm.font('FiraCode Nerd Font')
-- config.font = wezterm.font('Hack Nerd Font')
-- config.font = wezterm.font('JetBrainsMono NF')
-- config.font = wezterm.font('IBM Plex Mono')
-- config.font = wezterm.font('Monoid Nerd Font')
-- config.font = wezterm.font('Iosevka Nerd Font')
config.font = wezterm.font('ZedMono NF')
config.font_size = 16.0

-- Disable font ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.window_padding = {
  left = "0.5cell",
  right = "0.5cell",
  top = "0.5cell",
  bottom = "0.5cell",
}

config.use_fancy_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
config.enable_scroll_bar = true
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE" -- Hide the title bar
config.window_decorations = "RESIZE" -- Hide the title bar
config.color_scheme = scheme_for_appearance(get_appearance())

config.hide_tab_bar_if_only_one_tab = true

-- If background image is not set, set a random one
if global.background_image == nil then
  global.background_image = get_random_image(get_background_images({ include_simple = true }))
end
set_background_image()

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- =============================================================================
-- ==== Keybindings
-- =============================================================================

config.enable_kitty_keyboard = true
local main_mod = "CTRL|SHIFT"

config.keys = {
  { key = '<', mods = main_mod, action = act.MoveTabRelative(-1) },
  { key = '>', mods = main_mod, action = act.MoveTabRelative(1) },
  { key = 'h', mods = main_mod, action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = main_mod, action = act.ActivateTabRelative(1) },
  { key = 'k', mods = main_mod, action = act.ScrollByPage(-0.5) },
  { key = 'j', mods = main_mod, action = act.ScrollByPage(0.5) },

  { key = '%', mods = main_mod, action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = main_mod, action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Open scrollback in neovim
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.EmitEvent 'open-scrollback-in-neovim-pane',
  },

  -- Rename tab title
  {
    key = '?',
    mods = main_mod,
    action = rename_tab_action
  },
  -- Choose secret background image
  {
    key = "i",
    mods = main_mod,
    action = make_background_image_chooser(
      { include_simple = false, include_main = false, include_sketchy = false, include_secret = true },
      { max = 30 }
    )
  },
  -- Choose sketchy background image
  {
    key = "o",
    mods = main_mod,
    action = make_background_image_chooser(
      { include_simple = false, include_main = false, include_sketchy = true, include_secret = false },
      { max = 10 }
    )
  },
  -- Choose any non-secret background image
  {
    key = "b",
    mods = main_mod,
    action = make_background_image_chooser(
      { include_simple = true, include_main = true, include_sketchy = false, include_secret = false },
      { max = 20 }
    )
  },

  { key = "d", mods = main_mod, action = act.ShowDebugOverlay },
  { key = ":", mods = main_mod, action = act.ShowLauncher },
}

-- =============================================================================
-- ==== Event callbacks
-- =============================================================================

wezterm.on(
  'format-tab-title',
  ---@diagnostic disable-next-line: unused-local, redefined-local
  function(tab, tabs, panes, config, hover, max_width)
    local title = get_tab_title(tab)

    if tab.active_pane.is_zoomed then
      local subtitle = "*"
      -- local subtitle = tab.active_pane.title

      return title .. "[" .. subtitle .. "] "
    end

    if tab.is_active then
      --  Do some more processing if active tab
      return title
    end

    return title
  end
)

wezterm.on(
  'format-window-title',
  ---@diagnostic disable-next-line: unused-local, redefined-local
  function(tab, pane, tabs, panes, config)
    local title = get_tab_title(tab)
    return title
  end
)

-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)


local function make_scrollback_opener(input)
  local props = input or {}
  local open_in_pane = props.open_in_pane or false

  return function(window, pane)
    -- Retrieve the text from the pane
    local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

    -- Create a temporary file to pass to vim
    -- local file_name = os.tmpname()

    -- Generate a file for the current scrollback
    local formatted_time = os.date('%Y-%m-%d-%H-%M-%S', os.time())
    local file_name = wezterm.home_dir .. "/dotfiles/data/scrollbacks/" .. formatted_time

    local f = io.open(file_name, 'w+')

    if f == nil then
      return
    end

    f:write(text)
    f:flush()
    f:close()

    if not open_in_pane then
      -- Open in new tab
      window:perform_action(
        act.SpawnCommandInNewTab {
          label = "Open scrollback in neovim tab",
          args = { 'nvim', file_name },
        },
        pane
      )
    else
      -- Open in new pane
      local new_pane = pane:split {
        direction = "Bottom",
        args = { 'nvim', file_name },
      }

      window:perform_action(
        act.SetPaneZoomState(true),
        new_pane
      )
    end

    -- Wait "enough" time for vim to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    --
    -- Note: We don't strictly need to remove this file, but it is nice
    -- to avoid cluttering up the temporary directory.
    wezterm.sleep_ms(2000)
    os.remove(file_name)
  end
end

wezterm.on('open-scrollback-in-neovim-tab', make_scrollback_opener({ open_in_pane = false }))
wezterm.on('open-scrollback-in-neovim-pane', make_scrollback_opener({ open_in_pane = true }))

-- config.enable_wayland = false

-- Reload configuration every once in a while (setting a random wallpaper again)
-- wezterm.time.call_after(60 * 15, wezterm.reload_configuration)

-- and finally, return the configuration to wezterm
return config
