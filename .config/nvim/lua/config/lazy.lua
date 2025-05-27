local M = {}

function M.setup()
  -- Install lazy.nvim as manager
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
  local lockfile = os.getenv("LAZY_LOCK_FILE") or vim.fn.stdpath("config") .. "/lazy-lock.json"

  require("lazy").setup("plugins", {
    dev = {
      path = "~/projects/nvim_plugins",
    },
    lockfile = lockfile,
  })
end

return M
