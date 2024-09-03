local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.font = wezterm.font 'IntoneMono Nerd Font'
config.font_size = 12.0
config.window_padding = {
  top = 4,
  left = 0,
  right = 0,
  bottom = 0
}
-- and finally, return the configuration to wezterm
return config
