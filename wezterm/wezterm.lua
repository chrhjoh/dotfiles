local wezterm = require('wezterm')
local color_theme = require('color_scheme')
local tab_bar = require('tab_bar')
local keys = require('keys')
local window = require('windows')
local config = {}

config.use_ime = true
-- Fonts
config.font_size = 11
config.font = wezterm.font 'JetBrainsMono Nerd Font'

color_theme.add_color_theme_configurations(config)
tab_bar.add_tab_bar_configurations(config)
keys.add_key_configurations(config)
window.add_window_configurations(config)

-- Setup startups
require('startup')
return config
