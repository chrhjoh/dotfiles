local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}

---@param config Config
---@return Config
function M.setup(config)
  config.use_ime = true
  config.font_size = 12
  config.font = wezterm.font_with_fallback { "JetBrains Mono", "Symbols Nerd Font Mono" }
  config.use_fancy_tab_bar = false
  config.tab_max_width = 32
  config.status_update_interval = 250
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
