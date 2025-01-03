vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- add cursorline
vim.wo.cursorline = true
vim.wo.cursorlineopt = 'number'
-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noinsert'

vim.o.termguicolors = true

vim.opt.conceallevel = 1

vim.o.sessionoptions = 'buffers,curdir,folds,tabpages,winpos,winsize'
vim.o.laststatus = 3

vim.opt.spelllang = { 'en_us' }

-- Forces cursor into middle of page when scrolling
-- vim.o.so = 15

-- disable terminal sync to avoid cursor flicker
vim.o.termsync = false

vim.o.pumheight = 10

vim.opt.showcmdloc = 'statusline'
