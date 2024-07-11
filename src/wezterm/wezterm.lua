local wezterm = require("wezterm")      -- Pull in the wezterm API
local config = wezterm.config_builder() -- This will hold the configuration.

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
  right = 6,
  top = 2,
  bottom = 2,
}

config.use_fancy_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
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
    horizontal_align = "Right",
    vertical_align = "Bottom",
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
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  }
}

-- and finally, return the configuration to wezterm
return config
