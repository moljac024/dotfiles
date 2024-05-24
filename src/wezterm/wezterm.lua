-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font 'Fira Code'
config.font_size = 16.0

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    -- Possible values are "Light", "Dark"
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Solarized (dark) (terminal.sexy)'
    else
        return 'Solarized (light) (terminal.sexy)'
    end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- config.window_background_opacity = 0.9

config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config
