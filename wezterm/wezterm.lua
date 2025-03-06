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


---@diagnostic disable-next-line: unused-function, unused-local
local function filter(t, func)
  local out = {}
  for i = 1, #t do
    if func(t[i]) then
      table.insert(out, t[i])
    end
  end
  return out
end

---@diagnostic disable-next-line: unused-function, unused-local
local function map(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v, k)
  end
  return t
end


---@diagnostic disable-next-line: unused-function, unused-local
local function values(tbl)
  local t = {}
  for _, v in pairs(tbl) do
    table.insert(t, v)
  end
  return t
end

---@diagnostic disable-next-line: unused-function, unused-local
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

---@diagnostic disable-next-line: unused-function, unused-local
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
---@diagnostic disable-next-line: unused-function, unused-local
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

local function generate_unique_name(tab_info, existing_names, opts)
  opts = opts or {}
  existing_names = existing_names or {}

  local colors = { "red", "blue", "green", "yellow", "purple", "orange", "black", "white", "gray", "pink" }
  local adjectives = { "swift", "lazy", "brave", "fierce", "sneaky", "silent", "gentle", "wild", "bold", "clever" }
  local animals = { "fox", "wolf", "eagle", "panther", "tiger", "hawk", "bear", "lion", "rabbit", "owl" }

  local tries = 0
  local max_tries = 100 -- Prevent infinite loops

  while tries < max_tries do
    local color = colors[math.random(#colors)]
    local adjective = adjectives[math.random(#adjectives)]
    local animal = animals[math.random(#animals)]

    local parts = {
      color,
      animal
    }

    if opts.with_adjective then
      table.insert(parts, 2, adjective)
    end

    local name = table.concat(parts, "-")

    if not includes(existing_names, name) then
      return name
    end

    tries = tries + 1
  end

  -- Fallback: return the next number in sequence
  return tostring(tab_info.tab_id)

  -- Fallback: return the next number in sequence
  -- return tostring(#existing_names + 1)
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
  local color_scheme = wezterm.color.get_builtin_schemes()[color_scheme_name]
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

-- Tab title
local function get_tab_title(tab_info, opts)
  opts = opts or {}
  local tabs = opts.tabs or {}
  if (global.tab_names == nil) then
    global.tab_names = {}
  end

  local all_tab_ids = map(tabs, function(tab)
    return tostring(tab.tab_id)
  end)
  local tab_id = tostring(tab_info.tab_id)
  local existing_names = values(global.tab_names)
  local existing_title = tab_info.tab_title
  local title = tab_id

  if opts.include_pane_title then
    -- Use the title from the active pane in that tab
    return tab_info.active_pane.title
  end

  -- if the tab title is explicitly set, take that
  if existing_title and #existing_title > 1 then
    return existing_title
  end

  if global.tab_names[tab_id] ~= nil then
    return global.tab_names[tab_id]
  end

  -- Generate a random unique name for the tab
  title = generate_unique_name(tab_info, existing_names, { with_adjective = false })
  global.tab_names[tab_id] = title

  -- Clean up the global tab names
  for _, t in pairs(global.tab_names) do
    if not includes(all_tab_ids, t) then
      global.tab_names[t] = nil
    end
  end

  return title
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
-- ==== Config
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

-- Render the tab bar using the main terminal font
config.use_fancy_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
config.enable_scroll_bar = true
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE" -- Hide the title bar
config.window_decorations = "RESIZE" -- Hide the title bar
config.color_scheme = scheme_for_appearance(get_appearance())

config.hide_tab_bar_if_only_one_tab = false

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

-- config.enable_wayland = false

-- Reload configuration every once in a while (setting a random wallpaper again)
-- wezterm.time.call_after(60 * 15, wezterm.reload_configuration)

-- =============================================================================
-- ==== Keybindings
-- =============================================================================

-- config.disable_default_key_bindings = true
config.enable_kitty_keyboard = true
local main_mod = "CTRL|SHIFT"

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  -- Send "CTRL-S" to the terminal when pressing CTRL-S, CTRL-S
  {
    key = 's',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 's', mods = 'CTRL' },
  },

  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

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

  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'focus_pane',
      one_shot = false,
    },
  },
}

config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },
  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  focus_pane = {
    { key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
    { key = 'h',          action = act.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l',          action = act.ActivatePaneDirection 'Right' },

    { key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
    { key = 'k',          action = act.ActivatePaneDirection 'Up' },

    { key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
    { key = 'j',          action = act.ActivatePaneDirection 'Down' },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },
}


-- =============================================================================
-- ==== Event callbacks
-- =============================================================================

wezterm.on(
  'format-tab-title',
  ---@diagnostic disable-next-line: unused-local, redefined-local
  function(tab, tabs, panes, config, hover, max_width)
    local title = " " .. get_tab_title(tab, { tabs = tabs }) .. " "

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

---@diagnostic disable-next-line: unused-local
wezterm.on("update-status", function(window, pane)
  local current_config = window:effective_config()
  local scheme_name = current_config.color_scheme
  local builtins = wezterm.color.get_builtin_schemes()
  local colors = builtins[scheme_name] or {}
  local active_bg = colors.tab_bar.active_tab.bg_color
  local active_fg = colors.tab_bar.active_tab.fg_color

  local left = ""
  local right = ""

  -- If not in normal mode, show the current mode
  if window:active_key_table() then
    local mode_text = window:active_key_table():lower():gsub("_", " ")
    right = wezterm.format({
      { Foreground = { Color = active_fg } },
      { Background = { Color = active_bg } },
      { Text = " " .. mode_text .. "" },
    })
  end

  if window:leader_is_active() then
    left = wezterm.format({
      { Foreground = { Color = active_fg } },
      { Background = { Color = active_bg } },
      { Text = " LEADER " },
      'ResetAttributes',
      { Text = " " },
    })
  end

  window:set_left_status(left)
  window:set_right_status(right)
end)

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
          label = "Open scrollback in editor",
          args = { 'my-editor', file_name },
        },
        pane
      )
    else
      -- Open in new pane
      local new_pane = pane:split {
        direction = "Bottom",
        args = { 'my-editor', file_name },
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

-- and finally, return the configuration to wezterm
return config
