---@alias Tools table<string, ToolConfig>

---@class ToolConfig
---@field ensure_install? boolean
---@field mason_alias string?
---@field filetypes string[]?

---@class LspToolConfig: ToolConfig[]
---@field opts table<string, any>?

---@class FormatterToolConfig: ToolConfig[]

---@class DebuggerToolConfig: ToolConfig
---@field opts DebugOpts

---@class DebugOpts
---@field adapter dap.Adapter
---@field configurations dap.Configuration[]

---@class InstallOpts
---@field exclude? string[]
---@field update? boolean
---@field force? boolean

---@alias ToolType "formatters"|"debuggers"|"lsps"

-- Modfied from https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/handler/keys.lua
---@class KeysBase
---@field noremap? boolean
---@field remap? boolean
---@field expr? boolean
---@field nowait? boolean
---@field ft? string|string[]
---@field buffer? integer|boolean

---@class KeysDefaults: KeysBase
---@field desc_prefix? string
---@field mode? string|string[]

---@class KeysSpec: KeysBase
---@field [1] string lhs
---@field [2]? string|fun(): string?|false rhs
---@field desc? string
---@field mode? string|string[]
