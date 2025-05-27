local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local M = {}

function M.apply_to_config(config)
  config.font_size = 12
  config.font = wezterm.font_with_fallback { "JetBrains Mono", "Symbols Nerd Font Mono" }
  config.window_decorations = "RESIZE"
  config.default_domain = "local"
  config.unix_domains = { {
    name = "unix",
    connect_automatically = true,
  } }
  config.color_scheme = "Catppuccin Macchiato"
  config.command_palette_fg_color = utils.colors.text
  config.command_palette_bg_color = utils.colors.surface0
end

return M
