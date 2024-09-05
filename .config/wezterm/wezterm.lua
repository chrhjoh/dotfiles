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

-- NEVER DEFINE SSH DOMAINS PUBLICLY
-- open with wezterm connect unix
config.unix_domains = {
	{
		-- The name; must be unique amongst all domains
		name = 'unix',

		-- The path to the socket.  If unspecified, a resonable default
		-- value will be computed.

		-- socket_path = "/some/path",

		-- If true, do not attempt to start this server if we try and fail to
		-- connect to it.

		-- no_serve_automatically = false,

		-- If true, bypass checking for secure ownership of the
		-- socket_path.  This is not recommended on a multi-user
		-- system, but is useful for example when running the
		-- server inside a WSL container but with the socket
		-- on the host NTFS volume.

		-- skip_permissions_check = false,
	},
}

-- Setup startups
require('startup')
return config
