local wezterm = require('wezterm') --[[@as Wezterm]]
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

function M.setup()
  wezterm.on('gui-startup', function()
    mux.get_domain('unix'):attach()
  end)
end

return M
