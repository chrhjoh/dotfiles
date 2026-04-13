local M = {}

M.load_lazily = function(fn)
  vim.schedule(fn)
end

if vim.fn.argc(-1) == 0 then
  M.load_eager_if_arg = M.load_lazily
else
  M.load_eager_if_arg = function(fn)
    fn()
  end
end

function M.load_on_event(fn, event)
  vim.api.nvim_create_autocmd(event, {
    once = true,
    callback = fn,
  })
end

function M.load_on_ft(fn, ft)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    once = true,
    callback = fn,
  })
end

return M
