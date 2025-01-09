local M = {}

---@param tools ToolConfig[]
---@param opts? InstallOpts
local install = function(tools, opts)
  local registry = require("mason-registry")
  if opts and opts.update then
    registry.refresh()
  end
  local needs_install = {}
  for _, tool in pairs(tools) do
    if tool.mason == false then
      goto continue
    end
    local install_name = tool.mason_alias or tool.name
    if opts and opts.force then
      table.insert(needs_install, install_name)
    elseif registry.has_package(install_name) then
      local p = registry.get_package(install_name)
      if not p:is_installed() then
        table.insert(needs_install, install_name)
      end
    end
    ::continue::
  end
  if not vim.tbl_isempty(needs_install) then
    vim.cmd("MasonInstall " .. table.concat(needs_install, " "))
  else
    vim.notify("All tools have already been installed")
  end
end

local function get_all()
  local all_tools = {} ---@type ToolConfig[]
  local tools = require("config.tools")
  all_tools = vim.list_extend(all_tools, tools.debuggers)
  all_tools = vim.list_extend(all_tools, tools.formatters)
  all_tools = vim.list_extend(all_tools, tools.lsps)
  return all_tools
end

---@param opts? InstallOpts
M.install_all = function(opts)
  local all_tools = get_all()
  all_tools = vim.tbl_filter(function(tbl)
    return not vim.list_contains(opts and (opts.exclude or {}) or {}, tbl.name)
  end, all_tools)
  install(all_tools, opts)
end

---@param tools string[]
M.install = function(tools)
  local all_tools = get_all()
  all_tools = vim.tbl_filter(function(tbl)
    return vim.list_contains(tools, tbl.name)
  end, all_tools)
  install(all_tools)
end

function M.setup_debuggers()
  local dap = require("dap")
  local debuggers = require("config.tools").debuggers
  for _, tool in ipairs(debuggers) do
    for _, ft in ipairs(tool.filetypes) do
      if not dap.configurations[ft] and not dap.adapters then
        vim.notify("Got multiple configuration or adapter for filetype: " .. ft, vim.log.levels.WARN)
      end
      dap.adapters[ft] = tool.opts.adapter
      dap.configurations[ft] = tool.opts.configurations
    end
  end
end

---@param tooltype ToolType
---@return table<string, string[]>
function M.by_filetype(tooltype)
  local tools = require("config.tools")[tooltype]
  local result = {}
  for _, tool in pairs(tools) do
    local filetypes = tool.filetypes or {}
    for _, ft in ipairs(filetypes) do
      if not result[ft] then
        result[ft] = {}
      end

      table.insert(result[ft], tool.name)
    end
  end
  return result
end

return M
