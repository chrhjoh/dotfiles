local M = {}

---@param tools Tools
---@param opts? InstallOpts
local install = function(tools, opts)
  local registry = require("mason-registry")
  if opts and opts.update then
    registry.refresh()
  end
  local needs_install = {}
  for name, config in pairs(tools) do
    local install_name = config.mason_alias or name
    if opts and opts.force then
      table.insert(needs_install, install_name)
    elseif registry.has_package(install_name) then
      local p = registry.get_package(install_name)
      if not p:is_installed() then
        table.insert(needs_install, install_name)
      end
    end
  end
  if not vim.tbl_isempty(needs_install) then
    vim.cmd("MasonInstall " .. table.concat(needs_install, " "))
  else
    vim.notify("All tools have already been installed")
  end
end

M.install_ensured = function(opts)
  local configurations = require("config.tools")
  configurations = vim.tbl_extend("error", configurations.lsps, configurations.debuggers, configurations.formatters)
  local ensured = {}
  for name, config in pairs(configurations) do
    if config.ensure_install ~= false then
      ensured[name] = config
    end
  end
  install(ensured, opts)
end

function M.setup_debuggers()
  local dap = require("dap")
  local debuggers = require("config.tools").debuggers
  for name, config in ipairs(debuggers) do
    for _, ft in ipairs(config.filetypes) do
      if not dap.configurations[ft] and not dap.adapters then
        vim.notify("Got multiple configuration or adapter for filetype: " .. ft, vim.log.levels.WARN)
      end
      dap.adapters[ft] = config.opts.adapter
      dap.configurations[ft] = config.opts.configurations
    end
  end
end

---@return table<string, string[]>
function M.conform_by_ft()
  local tools = require("config.tools").formatters
  local result = {}
  for name, config in pairs(tools) do
    local filetypes = config.filetypes or {}
    for _, ft in ipairs(filetypes) do
      if not result[ft] then
        result[ft] = {}
      end

      table.insert(result[ft], name)
    end
  end
  return result
end

return M
