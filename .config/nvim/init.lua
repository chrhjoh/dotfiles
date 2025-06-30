if os.getenv("NVIM_TESTDIR") then
  vim.opt.runtimepath:prepend(os.getenv("NVIM_TESTDIR"))
end
_G.Utils = require("utils")
require("config.options")
require("config.lazy").setup()

-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require("config.autocommands")
end

-- Load keymaps and autocommands on VeryLazy
local group = vim.api.nvim_create_augroup("ConfigVeryLazy", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require("config.autocommands")
    end
    require("config.lsp")
    require("config.keymaps")
  end,
})
