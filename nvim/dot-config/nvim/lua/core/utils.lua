local M = {}

function M.plugin_dir(plugin)
  local pack = vim.pack.get { plugin }
  assert(#pack == 1, "Must only be one plugin returned")
  return pack[1].path
end

return M
