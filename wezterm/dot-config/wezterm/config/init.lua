local M = {}
local wezterm = require('wezterm') --[[@as Wezterm]]

---@return Config
function M.setup()
  local config = wezterm.config_builder()
  require('config.options').setup(config)
  require('config.keys').setup(config)
  require('config.colorscheme').setup(config)
  require('config.startup').setup()
  return config
end

return M
