local wezterm = require("wezterm")
local utils = require("utils")

wezterm.on("update-status", function(window, pane)
  local tabs = window:mux_window():tabs()
  local tabs_width = 0
  for idx, tab in ipairs(tabs) do
    local title = tab:get_title()
    if title == "" then
      title = tab:active_pane():get_title()
    end
    local idx_width = math.floor(math.log(idx, 10)) + 1
    tabs_width = tabs_width + idx_width + 2 + #title + 1
  end
  local full_width = window:active_tab():get_size().cols
  local max_left = math.floor(full_width / 2) - math.floor(tabs_width / 2) - 1

  window:set_left_status(
    wezterm.format { { Background = { Color = utils.colors.base } }, { Text = wezterm.pad_left(" ", max_left) } }
  )
end)

function M.apply_to_config(config)
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_tab_index_in_tab_bar = true
  config.show_new_tab_button_in_tab_bar = false
  config.show_close_tab_button_in_tabs = false
  config.window_frame = {
    font = wezterm.font { family = "JetBrains Mono", weight = "Bold" },
    font_size = 11,
    active_titlebar_bg = "none",
    inactive_titlebar_bg = "none",
  }
  return config
end

return M
