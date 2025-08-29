local wezterm = require("wezterm")
local M = {}

M.workspaces = {
  {
    name = "thesis",
    layout = function(window, tab, pane)
      pane:send_text("$EDITOR\n")
    end,
    directory = wezterm.home_dir .. "/Documents/phd_thesis",
  },
  {
    name = "projects",
    directory = wezterm.home_dir .. "/projects",
  },
  {
    name = "translation",
    layout = function(window, tab, pane)
      pane:send_text("$EDITOR\n")
    end,
    directory = wezterm.home_dir .. "/bitbucket/translation",
  },
}

return M
