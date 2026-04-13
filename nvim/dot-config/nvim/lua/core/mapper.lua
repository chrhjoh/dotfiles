local M = {}

---@alias KeyRhs string|fun(): string?|false

---@class KeyOpts : vim.keymap.set.Opts
---@field [1] string lhs
---@field [2] KeyRhs rhs
---@field mode? string|string[]

---@class KeyDefaults : vim.keymap.set.Opts
---@field mode? string|string[]
---@field prefix? string

---@param defaults KeyDefaults
---@return fun(opts: KeyOpts)
M.get = function(defaults)
  return function(opts)
    opts.mode = opts.mode and opts.mode or defaults.mode
    if opts.desc and defaults.prefix then
      opts.desc = defaults.prefix .. ": " .. opts.desc
    end

    M.map(opts)
  end
end

---@param opts KeyOpts
M.map = function(opts)
  local left = opts[1]
  local right = opts[2]
  local mode = opts.mode or "n"

  opts[1] = nil
  opts[2] = nil
  opts.mode = nil
  vim.keymap.set(mode, left, right, opts)
end

return M
