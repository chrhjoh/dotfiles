local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local M = {}

function M.apply_to_config(config)
  config.font_size = 11
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
  config.colors = {
    indexed = {
      [16] = utils.colors.base, -- No clue why, but fixes ipython colors (https://github.com/catppuccin/wezterm/issues/15)
    },
    tab_bar = {
      inactive_tab_edge = utils.colors.mantle,
      active_tab = { bg_color = utils.colors.mauve, fg_color = utils.colors.base },
      inactive_tab = { bg_color = utils.colors.base, fg_color = utils.colors.text },
      inactive_tab_hover = { bg_color = utils.colors.surface0, fg_color = utils.colors.text },
      new_tab = { bg_color = utils.colors.base, fg_color = utils.colors.text },
      new_tab_hover = { bg_color = utils.colors.surface0, fg_color = utils.colors.text },
    },
  }
end

return M
