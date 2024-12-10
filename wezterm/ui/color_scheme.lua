local wezterm = require('wezterm') --[[@ as Wezterm]]
local colors = require('utils.colors').colors
local M = {}

--Overwrite colors
local custom = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
custom.tab_bar.background = colors.base
custom.tab_bar.inactive_tab.bg_color = colors.base
custom.tab_bar.inactive_tab.fg_color = colors.text
custom.tab_bar.new_tab.bg_color = colors.base
custom.tab_bar.new_tab.fg_color = colors.text

function M.setup(config)
  config.color_schemes = {
    ['MYppuccin'] = custom,
  }
  config.color_scheme = 'MYppuccin'
end

M.scheme = custom

return M
