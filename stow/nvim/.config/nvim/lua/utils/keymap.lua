---@class Utils.Keymap
local M = {}

---@alias KeyMapper fun(opts: KeysSpec)
---@alias LazyKeyMapper fun(opts: KeysSpec): KeysSpec
---@alias LazyKeyListMapper fun(opts: KeysSpec[]): KeysSpec[]

---@param default_opts KeysDefaults
---@param opts KeysSpec
---@return KeysSpec
local apply_defaults = function(default_opts, opts)
  local defaults = vim.deepcopy(default_opts)
  local override = vim.deepcopy(opts)
  override.desc = defaults.desc_prefix and override.desc and (defaults.desc_prefix .. ": " .. override.desc)
    or override.desc
  override = vim.tbl_extend("force", defaults, override)
  return override
end

---@param opts KeysSpec
---@param keys table<string, any>
---@return table
local remove_opts = function(opts, keys)
  local keymap_opts = vim.deepcopy(opts)
  for _, key in ipairs(keys) do
    keymap_opts[key] = nil
  end
  return keymap_opts
end

local remove_lazy = { "desc_prefix" }
---@param default_opts KeysDefaults
---@return LazyKeyMapper
M.get_lazy_mapper = function(default_opts)
  return function(opts)
    opts = apply_defaults(default_opts, opts)
    return remove_opts(opts, remove_lazy)
  end
end

---@param default_opts KeysDefaults
---@return LazyKeyListMapper
M.get_lazy_list_mapper = function(default_opts)
  return function(opts)
    local keys = {}
    for _, opt in ipairs(opts) do
      opt = apply_defaults(default_opts, opt)
      opt = remove_opts(opt, remove_lazy)
      table.insert(keys, opt)
    end

    return keys
  end
end

local remove_keymap = { "mode", "desc_prefix", 1, 2 }
---@param default_opts KeysDefaults
---@return KeyMapper
M.get_mapper = function(default_opts)
  return function(opts)
    opts = apply_defaults(default_opts, opts)
    local vim_opts = remove_opts(opts, remove_keymap)
    vim.keymap.set(opts.mode, opts[1], opts[2], vim_opts)
  end
end

return M
