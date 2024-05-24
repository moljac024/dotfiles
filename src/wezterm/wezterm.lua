-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("Fira Code")
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
		return "Solarized Dark (Gogh)"
	else
		return "Solarized Light (Gogh)"
	end
end

config.window_frame = {
	border_left_width = "0.25cell",
	border_right_width = "0.25cell",
	border_bottom_height = "0.125cell",
	border_top_height = "0.125cell",
	border_left_color = "black",
	border_right_color = "black",
	border_bottom_color = "black",
	border_top_color = "black",

	font = wezterm.font("Fira Code"),
	font_size = 12,
}
config.window_padding = {
	left = 2,
	right = 6,
	top = 0,
	bottom = 0,
}

config.color_scheme = scheme_for_appearance(get_appearance())
-- config.window_background_opacity = 0.9
config.use_fancy_tab_bar = true
config.enable_scroll_bar = true

config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}

-- and finally, return the configuration to wezterm
return config
