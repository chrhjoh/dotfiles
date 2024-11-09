vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.loader.enable()
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.autocommands")
require("config.commands")
require("config.filetypes")
require("config.keymaps")
require("config.options")

require("lazy").setup({
    { import = "plugins.ui" },
    { import = "plugins.utils" },
    { import = "plugins.editor" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    { import = "plugins.ai" },
}, {
    dev = {
        path = "~/projects/nvim_plugins",
    },
    lockfile = vim.env.DOTFILES .. "/lazy-lock.json" or vim.fn.stdpath("config") .. "/lazy-lock.json"

})
