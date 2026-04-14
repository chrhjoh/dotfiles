local M = {}

---@param fn function
M.load_later = function(fn)
  vim.schedule(fn)
end

local load_eagerly = vim.fn.argc(-1) ~= 0

---@param fn function
function M.load_eager_if_arg(fn)
  if load_eagerly then
    fn()
  else
    M.load_later(fn)
  end
end

---@param event string|string[]
---@param fn function
function M.load_on_event(event, fn)
  vim.api.nvim_create_autocmd(event, {
    once = true,
    callback = fn,
  })
end

---@param ft string|string[]
---@param fn function
function M.load_on_ft(ft, fn)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    once = true,
    callback = fn,
  })
end

return M
