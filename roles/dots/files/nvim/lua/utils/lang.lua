---@class Utils.Lang
local M = {}

M.get_roots = function()
  return coroutine.wrap(function()
    local cwd = vim.fn.getcwd()
    coroutine.yield(cwd)

    local wincwd = vim.fn.getcwd(0)
    if wincwd ~= cwd then
      coroutine.yield(wincwd)
    end

    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.config.root_dir then
        coroutine.yield(client.config.root_dir)
      end
    end
  end)
end

M.get_python_path = function()
  local function python_exe(path)
    return path .. "/bin/python"
  end
  local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv_path then
    return python_exe(venv_path)
  end

  for root in M.get_roots() do
    for _, folder in ipairs { "venv", ".venv", "env", ".env" } do
      local path = root .. "/" .. folder
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == "directory" then
        return python_exe(path)
      end
    end
  end

  return nil
end

return M
