local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()
require("options").apply_to_config(config)
require("keys").apply_to_config(config)
require("workspaces").setup()

return config
