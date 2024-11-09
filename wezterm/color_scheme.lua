local wezterm = require('wezterm')
local M = {}
-- Color Scheme
local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.tab_bar.background = "#1e1e2e"
custom.tab_bar.inactive_tab.bg_color = "#313244"
custom.tab_bar.inactive_tab.fg_color = "#cdd6f4"
custom.tab_bar.new_tab.bg_color = "#1e1e2e"
custom.tab_bar.new_tab.fg_color = "#cdd6f4"


function M.add_color_theme_configurations(config)
	config.color_schemes = {
		["MYppuccin"] = custom,
	}
	config.color_scheme = "MYppuccin"
end

return M
