local wezterm = require("wezterm")      -- Pull in the wezterm API
local config = wezterm.config_builder() -- This will hold the configuration.

-- =============================================================================
-- ==== Appearance
-- =============================================================================

local font = {
  name = 'FiraCode Nerd Font',
  -- name = 'Iosevka Nerd Font',
  size = 16.0,
}

config.font = wezterm.font(font.name)
config.font_size = font.size

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

config.window_padding = {
  left = 2,
  right = 6, -- Makes the scrollbar a little wider
  top = 0,
  bottom = 0,
}

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE" -- Hide the title bar

local color_scheme_name = scheme_for_appearance(get_appearance())
local color_scheme = wezterm.get_builtin_color_schemes()[color_scheme_name]
local bg_color = wezterm.color.parse(color_scheme.background)
config.color_scheme = color_scheme_name
config.background = {
  { source = { Color = bg_color }, width = '100%', height = '100%' },
  {
    source = {
      File = wezterm.home_dir .. "/dotfiles/src/backgrounds/tyrande-transparent.png",
    },
    opacity = 0.15,
    hsb = { brightness = 0.5 }
  },
}

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}


-- =============================================================================
-- ==== Keybindings
-- =============================================================================

local act = wezterm.action
local main_mod = "CTRL|SHIFT"
config.keys = {
  { key = 'h', mods = main_mod, action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = main_mod, action = act.ActivateTabRelative(1) },
  { key = 'k', mods = main_mod, action = act.ScrollByPage(-0.5) },
  { key = 'j', mods = main_mod, action = act.ScrollByPage(0.5) },
}

-- and finally, return the configuration to wezterm
return config
