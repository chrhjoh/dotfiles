-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Enable mouse mode
vim.o.mouse = "a"

-- Clipboard
vim.o.clipboard = "unnamedplus"
vim.g.clipboard = "osc52"

-- Indent
vim.o.breakindent = true

-- Undo
vim.o.undofile = true

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- UpdateTime
vim.o.updatetime = 250

-- Sessions
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winpos,winsize"

-- Forces cursor into middle of page when scrolling
vim.o.so = 0

-- Statusline
vim.o.showcmdloc = "statusline"
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.ruler = false

-- Completion
vim.g.completion = true
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.pumheight = 10

-- Window
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.cursorline = true
vim.wo.cursorlineopt = "number"

vim.wo.signcolumn = "yes"

-- Terminal
vim.o.termsync = false
vim.o.termguicolors = true

-- Conceal
vim.o.conceallevel = 2

local opt = vim.opt

opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.timeoutlen = 300
opt.wildmode = "longest:full,full"
opt.splitright = true
opt.virtualedit = "block"
-- Spelling
opt.spelllang = "en_us"
opt.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"

vim.o.foldlevel = 10
