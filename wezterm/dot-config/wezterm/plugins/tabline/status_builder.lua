local components = require("plugins.tabline.components")
local M = {}

---@param window Window
---@param pane Pane
---@return string
function M.build_left_status(window, pane)
  local domain = components.DomainComponent(window, pane)
  local workspace = components.WorkspaceComponent(window, pane)
  return domain .. workspace
end

---@param window Window
---@param pane Pane
---@return string
function M.build_right_status(window, pane)
  local host = components.HostComponent(window, pane)
  local cpu = components.CpuComponent(window, pane, 5)
  local ram = components.RamComponent(window, pane, 5)

  return ram .. "|" .. cpu .. host
end

return M
