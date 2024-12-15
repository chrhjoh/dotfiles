local wezterm = require('wezterm') --[[@as Wezterm]]
local actions = wezterm.action
local M = {}

function M.setup()
  wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    wezterm.log_info('{name}')

    if name == 'ZEN_MODE' then
      local incremental = value:find('+')
      local number_value = tonumber(value)
      if number_value == nil then
        return
      end
      if incremental ~= nil then
        while number_value > 0 do
          window:perform_action(actions.IncreaseFontSize {}, pane)
          number_value = number_value - 1
        end
        overrides.enable_tab_bar = false
      elseif number_value < 0 then
        window:perform_action(actions.ResetFontSize {}, pane)
        overrides.font_size = nil
        overrides.enable_tab_bar = true
      else
        overrides.font_size = number_value
        overrides.enable_tab_bar = false
      end
    end
    window:set_config_overrides(overrides)
  end)
end

return M
