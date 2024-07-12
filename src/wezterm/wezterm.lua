local wezterm = require("wezterm")      -- Pull in the wezterm API
local config = wezterm.config_builder() -- This will hold the configuration.
local act = wezterm.action

-- =============================================================================
-- ==== Functions
-- =============================================================================

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

local function set_background()
  local color_scheme_name = scheme_for_appearance(get_appearance())
  local color_scheme = wezterm.get_builtin_color_schemes()[color_scheme_name]
  local bg_color = wezterm.color.parse(color_scheme.background)
  local base_wallpaper_dir = wezterm.home_dir .. "/dotfiles/src/backgrounds/"

  local images = { "tyrande-transparent.png", "nature2.png", "nature4.png" }
  local image = images[math.random(#images)]

  config.background = {
    { source = { Color = bg_color }, width = '100%', height = '100%' },
    {
      source = {
        File = base_wallpaper_dir .. image
      },
      horizontal_align = "Right",
      vertical_align = "Bottom",
      opacity = 0.15,
      hsb = { brightness = 0.5 }
    },
  }
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
  left = 2,
  right = 6,
  top = 2,
  bottom = 2,
}

config.use_fancy_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
config.enable_scroll_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE" -- Hide the title bar
config.color_scheme = scheme_for_appearance(get_appearance())

set_background()

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- =============================================================================
-- ==== Keybindings
-- =============================================================================

local main_mod = "CTRL|SHIFT"

config.keys = {
  { key = '<', mods = main_mod, action = act.MoveTabRelative(-1) },
  { key = '>', mods = main_mod, action = act.MoveTabRelative(1) },
  { key = 'h', mods = main_mod, action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = main_mod, action = act.ActivateTabRelative(1) },
  { key = 'k', mods = main_mod, action = act.ScrollByPage(-0.5) },
  { key = 'j', mods = main_mod, action = act.ScrollByPage(0.5) },

  -- Rename tab title
  {
    key = '"',
    mods = main_mod,
    action = rename_tab_action
  }
}

-- =============================================================================
-- ==== Event callbacks
-- =============================================================================

wezterm.on(
  'format-tab-title',
  ---@diagnostic disable-next-line: unused-local, redefined-local
  function(tab, tabs, panes, config, hover, max_width)
    local title = get_tab_title(tab)
    if tab.is_active then
      --  Do some more processing if active tab
      return title
    end
    return title
  end
)

-- Reload configuration every once in a while (setting a random wallpaper again)
wezterm.time.call_after(60 * 15, wezterm.reload_configuration)

-- and finally, return the configuration to wezterm
return config
