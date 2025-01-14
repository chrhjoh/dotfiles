local wezterm = require('wezterm') --[[@as Wezterm]]
local mux = wezterm.mux

local default_project_layout = function(window, tab, pane)
  pane:send_text('$EDITOR\n')
  local shell_pane = pane:split { direction = 'Left' }
  shell_pane:split { direction = 'Top' }
end

local default_opts = { layout = function(window, tab, pane) end, width = 50, height = 50 }

local workspaces = {
  {
    name = 'dotfiles',
    layout = function(window, tab, pane)
      pane:send_text('$EDITOR\n')
    end,
    directory = wezterm.home_dir .. '/.dotfiles',
  },
  {
    name = 'thesis',
    layout = function(window, tab, pane)
      pane:send_text('$EDITOR\n')
    end,
    directory = wezterm.home_dir .. '/Documents/thesis',
  },
  {
    name = 'projects',
    layout = default_project_layout,
    directory = wezterm.home_dir .. '/projects',
  },
}
local function setup_workspace(workspace)
  local tab, pane, window = mux.spawn_window {
    workspace = workspace.name,
    cwd = workspace.directory,
    height = workspace.height or default_opts.height,
    width = workspace.height or default_opts.height,
  }
  local layout_fn = workspace.layout or default_opts.layout
  layout_fn(window, tab, pane)
end

local M = {}

function M.setup()
  wezterm.on('mux-startup', function()
    for _, workspace in ipairs(workspaces) do
      setup_workspace(workspace)
    end
  end)
  wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)
end
return M
