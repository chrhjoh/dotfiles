local wezterm = require("wezterm") --[[@ as Wezterm]]
local colors = require("utils.colors").colors
local status = require("plugins.tabline.status_builder")
local tab_title = require("plugins.tabline.tab_title_builder")
local utils = require("plugins.tabline.utils")
local M = {}

---@param config Config
function M.setup(config)
  wezterm.on("update-status", function(window, pane)
    window:set_left_status(status.build_left_status(window, pane))
    window:set_right_status(status.build_right_status(window, pane))
  end)

  wezterm.on("format-tab-title", function(tab, tabs, panes, event_config, hover, max_width)
    local title
    if tab.is_active then
      title = tab_title.build_active_title(tab, tabs, panes, event_config, hover, max_width)
    else
      title = tab_title.build_inactive_title(tab, tabs, panes, event_config, hover, max_width)
    end
    return title
  end)
end

return M
