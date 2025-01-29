local wezterm = require("wezterm") --[[@as Wezterm]]
local colors = require("utils.colors").colors
local symbols = wezterm.nerdfonts
local tabutils = require("plugins.tabline.utils")
local M = {}

---@param window Window
---@param pane Pane
---@return string
function M.DomainComponent(window, pane)
  local component = {}
  local domain = pane:get_domain_name()
  local bg_color = tabutils.color_by_mode(tabutils.get_current_mode(window))

  table.insert(component, { Foreground = { Color = colors.base } })
  table.insert(component, { Background = { Color = bg_color } })
  table.insert(component, { Text = " " .. symbols.md_domain .. " " .. domain .. " " })
  return wezterm.format(component)
end

---@param window Window
---@param pane Pane
---@return string
function M.WorkspaceComponent(window, pane)
  local component = {}
  local workspace = string.match(window:active_workspace(), "[^/\\]+$")

  table.insert(component, { Foreground = { Color = colors.text } })
  table.insert(component, { Background = { Color = colors.surface0 } })
  table.insert(component, { Text = " " .. symbols.cod_terminal_tmux .. " " .. workspace .. " " })
  return wezterm.format(component)
end

---@param window Window
---@param pane Pane
---@return string
function M.HostComponent(window, pane)
  local component = {}
  local workspace = tabutils.resolve_hostname(window)
  local bg_color = tabutils.color_by_mode(tabutils.get_current_mode(window))

  table.insert(component, { Foreground = { Color = colors.base } })
  table.insert(component, { Background = { Color = bg_color } })
  table.insert(component, { Text = " " .. symbols.md_network_pos .. " " .. workspace .. " " })
  return wezterm.format(component)
end

---@param window Window
---@param pane Pane
---@return string
function M.CpuComponent(window, pane, update_interval)
  local component = {}
  local cpu = tabutils.cpu_usage(update_interval)

  table.insert(component, { Foreground = { Color = colors.text } })
  table.insert(component, { Background = { Color = colors.base } })
  table.insert(component, { Text = " " .. symbols.oct_cpu .. "  " .. cpu .. " " })
  return wezterm.format(component)
end

---@param window Window
---@param pane Pane
---@return string
function M.RamComponent(window, pane, update_interval)
  local component = {}
  local ram = tabutils.ram_usage(update_interval)

  table.insert(component, { Foreground = { Color = colors.text } })
  table.insert(component, { Background = { Color = colors.base } })
  table.insert(component, { Text = " " .. symbols.cod_server .. "  " .. ram .. " " })
  return wezterm.format(component)
end
return M
