local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}

---@param config Config
---@return Config
function M.setup(config)
  config.use_ime = true
  config.font_size = 12
  config.font = wezterm.font_with_fallback { "JetBrainsMono Nerd Font", "Monaco" }
  config.use_fancy_tab_bar = false
  config.tab_max_width = 32
  config.status_update_interval = 250
  config.integrated_title_button_alignment = "Right"
  config.integrated_title_button_style = "Gnome"
  config.command_palette_font_size = 14
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.window_padding = {
    left = 0,
    right = 0,
    top = 10,
    bottom = 0,
  }
  config.unix_domains = { {
    name = "unix",
    connect_automatically = true,
  } }
  config.default_domain = "local"
  return config
end

return M
