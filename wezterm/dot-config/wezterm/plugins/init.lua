local M = {}

---@param config Config
function M.setup(config)
  require('plugins.tabline').setup(config)
  require('plugins.copy')
end

return M
