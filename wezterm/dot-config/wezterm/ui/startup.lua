local wezterm = require('wezterm') --[[@as Wezterm]]
local actions = wezterm.action
local mux = wezterm.mux

local M = {}

function M.setup()
  wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)

  wezterm.on('gui-attached', function(domain)
    -- maximize all displayed windows on startup
    local workspace = mux.get_active_workspace()
    for _, window in ipairs(mux.all_windows()) do
      if window:get_workspace() == workspace then
        window:gui_window():maximize()
      end
    end
  end)
end

return M
