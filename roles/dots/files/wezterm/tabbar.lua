local wezterm = require("wezterm")
local symbols = wezterm.nerdfonts
local utils = require("utils")

local mode_colors = {
  NORMAL = utils.colors.surface1,
  COPY = utils.colors.yellow,
  SEARCH = utils.colors.green,
  LEADER = utils.colors.red,
}

wezterm.on("update-status", function(window, pane)
  local mode_color = mode_colors[utils.get_current_mode(window)]
  if mode_color == nil then
    mode_color = mode_colors["NORMAL"]
  end
  local _, domain_name = pcall(function()
    return pane:get_domain_name()
  end)
  domain_name = type(domain_name) == "string" and domain_name or "Unknown"
  local domain = wezterm.format {
    { Foreground = { Color = utils.colors.text } },
    { Background = { Color = utils.colors.surface0 } },
    { Text = " " .. symbols.md_domain .. " " .. domain_name .. " " },
  }
  local workspace = wezterm.format {
    { Foreground = { Color = utils.get_current_mode(window) == "NORMAL" and utils.colors.text or utils.colors.base } },
    { Background = { Color = mode_color } },
    { Text = " " .. symbols.cod_terminal_tmux .. " " .. window:active_workspace() .. " " },
  }
  window:set_right_status(domain .. workspace)
end)

function M.apply_to_config(config)
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true
  config.window_frame = {
    font = wezterm.font { family = "JetBrains Mono", weight = "Bold" },
    font_size = 11,
    active_titlebar_bg = "none",
    inactive_titlebar_bg = "none",
  }
  return config
end

return M
