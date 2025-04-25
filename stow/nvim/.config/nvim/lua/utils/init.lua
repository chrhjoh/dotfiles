---@class Utils
---@field icons Utils.Icons
---@field keymap Utils.Keymap
---@field lang Utils.Lang
---@field root Utils.Root
local M = setmetatable({}, {
  __index = function(_, key)
    return require("utils." .. key)
  end,
})

M.get_visual_range = function()
  if not M.is_visual_mode() then
    return
  end
  -- This is the best way to get the visual selection at the moment
  -- https://github.com/neovim/neovim/pull/13896
  local _, start_lnum, _, _ = unpack(vim.fn.getpos("v"))
  local _, end_lnum, _, _, _ = unpack(vim.fn.getcurpos())
  if start_lnum > end_lnum then
    start_lnum, end_lnum = end_lnum, start_lnum
  end
  return { start_lnum = start_lnum, end_lnum = end_lnum }
end

M.is_visual_mode = function()
  local mode = vim.api.nvim_get_mode().mode
  return mode:match("^[vV]") ~= nil
end

-- Dot repetition of a custom mapping breaks as soon as there is a dot repeatable normal
-- mode command inside the mapping. This function restores the dot repetition of
-- the mapping while preserving the [count] when called as last statement inside
-- the custom mapping
M.restore_dot_repetition = function(count)
  count = count or ""
  local callback = vim.go.operatorfunc
  vim.go.operatorfunc = ""
  vim.cmd("silent! normal " .. count .. "g@l")
  vim.go.operatorfunc = callback
end

return M
