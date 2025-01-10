local wezterm = require('wezterm') --[[@as Wezterm]]
local M = {}

---@param config Config
---@return Config
function M.setup(config)
  config.use_ime = true
  config.font_size = 12
  config.font = wezterm.font_with_fallback { 'JetBrainsMono Nerd Font', 'Monaco' }
  config.window_decorations = 'RESIZE'
  config.window_padding = {
    left = 0,
    right = 0,
    top = 10,
    bottom = 0,
  }
  return config
end

return M
