local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}

M.workspaces = {
  {
    name = "dotfiles",
    layout = function(window, tab, pane)
      pane:send_text("$EDITOR\n")
    end,
    directory = wezterm.home_dir .. "/.dotfiles",
  },
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
  {
    name = "obsidian_personal",
    layout = function(window, tab, pane)
      pane:send_text("cd $OBSIDIAN_HOME/Personal\n")
      pane:send_text("$EDITOR\n")
    end,
    directory = wezterm.home_dir,
  },
  {

    name = "obsidian_work",
    layout = function(window, tab, pane)
      pane:send_text("cd $OBSIDIAN_HOME/Work\n")
      pane:send_text("$EDITOR\n")
    end,
    directory = wezterm.home_dir,
  },
}

return M
