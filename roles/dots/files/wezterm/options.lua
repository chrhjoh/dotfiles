local wezterm = require("wezterm")
local utils = require("utils")
local M = {}

function M.apply_to_config(config)
  config.font_size = 11
  config.font = wezterm.font_with_fallback { "JetBrains Mono", "Symbols Nerd Font Mono" }
  config.window_decorations = "RESIZE"
  config.unix_domains = { {
    name = "unix",
    connect_automatically = true,
  } }
  config.default_gui_startup_args =
    { "start", "--always-new-process", "--domain", "unix", "--attach", "--workspace", "default" }
  config.color_scheme = "Catppuccin Mocha"
  config.window_background_opacity = 1
  config.command_palette_fg_color = utils.colors.text
  config.command_palette_bg_color = utils.colors.surface0
  config.window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  }
  config.colors = {
    indexed = {
      [16] = utils.colors.base, -- No clue why, but fixes ipython colors (https://github.com/catppuccin/wezterm/issues/15)
    },
    tab_bar = {
      inactive_tab_edge = "none",
      active_tab = { bg_color = utils.colors.red, fg_color = utils.colors.base },
      inactive_tab = { bg_color = utils.colors.crust, fg_color = utils.colors.text },
      inactive_tab_hover = { bg_color = utils.colors.surface1, fg_color = utils.colors.text },
    },
  }
end

return M
