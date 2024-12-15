local wezterm = require('wezterm') --[[@as Wezterm]]
local config = wezterm.config_builder()
config.use_ime = true

require('ui.color_scheme').setup(config)
require('ui.tabline').setup(config)
require('config.keys').setup(config)
require('ui.windows').setup(config)
require('ui.zen-mode').setup()
require('ui.startup').setup()

return config
