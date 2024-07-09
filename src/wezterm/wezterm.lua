-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()
local font = "Iosevka Nerd Font"

config.font = wezterm.font(font)
config.font_size = 16.0

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

config.color_scheme = scheme_for_appearance(get_appearance())
-- config.window_background_opacity = 0.9
config.use_fancy_tab_bar = false
config.enable_scroll_bar = true

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- and finally, return the configuration to wezterm
return config
