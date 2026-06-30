---@class Core
---@field icons CoreIcons
---@field loader CoreLoader
---@field mapper CoreMapper
---@field utils CoreUtils
---@field options CoreOptions
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("core." .. k)
    return t[k]
  end,
})

return M
