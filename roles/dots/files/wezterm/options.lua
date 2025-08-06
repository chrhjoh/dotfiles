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
  config.default_gui_startup_args = { "connect", "unix", "--workspace", "default" }
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
      inactive_tab = { bg_color = utils.colors.mantle, fg_color = utils.colors.text },
      inactive_tab_hover = { bg_color = utils.colors.surface1, fg_color = utils.colors.text },
    },
  }
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = false
  config.show_tab_index_in_tab_bar = true
  config.show_new_tab_button_in_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_close_tab_button_in_tabs = false
  config.window_frame = {
    font = wezterm.font { family = "JetBrains Mono", weight = "Bold" },
    font_size = 11,
    active_titlebar_bg = "none",
    inactive_titlebar_bg = "none",
  }
end

return M
