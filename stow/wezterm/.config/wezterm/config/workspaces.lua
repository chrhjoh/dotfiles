local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local default_opts = { layout = function(window, tab, pane) end, width = 50, height = 50 }

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
  local host = wezterm.hostname()
  local workspaces
  local workspace_file = wezterm.config_dir .. "/config/hosts/" .. host .. ".lua"
  if file_exists(workspace_file) then
    workspaces = require("config.hosts." .. host).workspaces
  else
    workspaces = {}
  end
  wezterm.on("mux-startup", function()
    for _, workspace in ipairs(workspaces) do
      setup_workspace(workspace)
    end
  end)
  wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)
end
return M
