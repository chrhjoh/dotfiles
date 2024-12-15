local wezterm = require('wezterm') --[[@ as Wezterm]]
local M = {}

---@param config Config
function M.setup(config)
  config.font_size = 11
  config.font = wezterm.font_with_fallback { 'JetBrainsMono Nerd Font', 'Monaco' }
end

return M
