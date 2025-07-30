-- stylua: ignore start
local nmap =            Utils.keymap.get_mapper { mode = "n" }
local vmap =            Utils.keymap.get_mapper { mode = "v" }
local imap =            Utils.keymap.get_mapper { mode = "i" }
local yank_map =        Utils.keymap.get_mapper { mode = "n", desc_prefix = "Yank" }
local list_map =        Utils.keymap.get_mapper { mode = "n", desc_prefix = "List" }
local buffer_map =      Utils.keymap.get_mapper { mode = "n", desc_prefix = "Buffer" }
local diagnostic_map =  Utils.keymap.get_mapper { mode = "n", desc_prefix = "Diagnostics" }
local window_map =      Utils.keymap.get_mapper { mode = "n", desc_prefix = "Window" }
local file_map =        Utils.keymap.get_mapper { mode = "n", desc_prefix = "File" }
local source_map =      Utils.keymap.get_mapper { mode = "n", desc_prefix = "Source" }

nmap { "<Space>",   "<Nop>",          mode = { "n", "v" }, silent = true }
nmap { "<leader>Q", "<cmd>quit<cr>",  desc = "Quit Neovim" }

nmap( {"<esc>", function() vim.cmd("noh") vim.cmd("stopinsert") return "<esc>" end, mode={ "i", "n", "s" },  expr = true, desc = "Escape and Clear hlsearch" })

-- Remap for dealing with word wrap
nmap { "k", "v:count == 0 ? 'gk' : 'k'", silent = true, expr = true }
nmap { "j", "v:count == 0 ? 'gj' : 'j'", silent = true, expr = true }

nmap{"x", '"_x', desc = "Delete character", noremap = true}

-- Automatic reselect after indent
vmap { "<", "<gv" }
vmap { ">", ">gv" }

yank_map { "<leader>yP",  ':let @* = expand("%:p")<CR>',  desc = "Yank Absolute Path" }
yank_map { "<leader>yp",  ':let @* = expand("%")<CR>',    desc = "Yank Relative Path" }
yank_map { "<leader>y.",  ':let @* = expand("%:t")<CR>',  desc = "Yank Filename" }
yank_map { "<leader>p",   '"0p<cr>',                      desc = "Put from last yank registry" }
yank_map { "<leader>P",   "<CMD>YankyRingHistory<CR>",    desc = "Put from yank history" }

-- Moving between buffers
buffer_map { "<TAB>",       ":bn<CR>",                desc = "Next",      silent = true }
buffer_map { "<S-TAB>",     ":bp<CR>",                desc = "Previous",  silent = true }
buffer_map { "[b",          "<cmd>bprevious<cr>",     desc = "Previous" }
buffer_map { "]b",          "<cmd>bnext<cr>",         desc = "Next" }
buffer_map { "<leader>bb",  "<cmd>e #<cr>",           desc = "Switch to Other" }
buffer_map { "<leader>`",   "<cmd>e #<cr>",           desc = "Switch to Other" }
buffer_map { "<leader>bd",  Snacks.bufdelete.delete,  desc = "Delete" }
buffer_map { "<leader>bo",  Snacks.bufdelete.other,   desc = "Delete All Other" }
buffer_map { "<leader>bA",  Snacks.bufdelete.all,     desc = "Delete all" }
buffer_map {
  "<leader>bc",
  "<cmd>let @+ = expand('%:p')<cr>",
  desc = "Copy relative path to clipboard",
}

-- Notifications
nmap { "<leader>m", "<cmd>messages<CR>", desc = "Messages",      silent = true }

-- Moving over quickfix items quickly
nmap { "<C-n>", "<cmd>cn<CR>", desc = "Next item in list",      silent = true }
nmap { "<C-p>", "<cmd>cp<CR>", desc = "Previous item in list",  silent = true }
nmap {
  "[q",function() 
    local ok, err = pcall(vim.cmd.cprev)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,
  desc = "Previous Quickfix Item",
}
nmap {
  "]q",
  function()
      local ok, err = pcall(vim.cmd.cnext)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
  end,
  desc = "Next Quickfix Item",
}

-- Save file
nmap { "<C-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save File", silent = true }

-- Lists
local window_is_open = function(variable)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == variable then
      return true
    end
  end
  return false
end

list_map {
  "<leader>l",
  function()
    if window_is_open("quickfix") then
      vim.cmd("cclose")
    else
      vim.cmd("copen")
    end
  end,
  desc = "Toggle Quickfix List",
}

-- diagnostic
local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count=count }
  end
end

diagnostic_map { "<leader>cd",  vim.diagnostic.open_float,        desc = "Line" }
diagnostic_map { "<C-k>",       vim.diagnostic.open_float,        desc = "Line" }
diagnostic_map { "]d",          diagnostic_goto(1),            desc = "Next" }
diagnostic_map { "[d",          diagnostic_goto(-1),           desc = "Previous" }
diagnostic_map { "]e",          diagnostic_goto(1, "ERROR"),   desc = "Next Error" }
diagnostic_map { "[e",          diagnostic_goto(-1, "ERROR"),  desc = "Previous Error" }
diagnostic_map { "]w",          diagnostic_goto(true, "WARN"),    desc = "Next Warning" }
diagnostic_map { "[w",          diagnostic_goto(false, "WARN"),   desc = "Previous Warning" }

window_map { "<leader>ww",  "<C-W>p", desc = "Other",       remap = true }
window_map { "<leader>wd",  "<C-W>c", desc = "Delete",      remap = true }
window_map { "<leader>-",   "<C-W>s", desc = "Split Below", remap = true }
window_map { "<leader>|",   "<C-W>v", desc = "Split Right", remap = true }

window_map { "<C-Up>",    "<cmd>resize +2<cr>",           desc = "Increase Height" }
window_map { "<C-Down>",  "<cmd>resize -2<cr>",           desc = "Decrease Height" }
window_map { "<C-Left>",  "<cmd>vertical resize -2<cr>",  desc = "Decrease Width" }
window_map { "<C-Right>", "<cmd>vertical resize +2<cr>",  desc = "Increase Width" }

-- new file
file_map { "<leader>fn", "<cmd>enew<cr>", desc = "New File" }

-- Move around
imap { "<c-l>", "<right>" }
imap { "<c-k>", "<up>" }
imap { "<c-j>", "<down>" }
imap { "<c-h>", "<left>" }

source_map {"<leader>X", "<cmd>source % <CR>",   desc = "Source current Lua file",       silent = true }
source_map { "<leader>x", ":.lua<CR>",            desc = "Source current Lua line",       silent = true }
source_map { "<leader>x", ":lua<CR>",             desc = "Source current Lua selection",  silent = true, mode = "v" }
-- stylua: ignore end

-- Toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
  :map("<leader>uc")

-- Toogle various ui elements
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.diagnostics({ bufnr = 0 }):map("<leader>uD")
Snacks.toggle.zen():map("<leader>uZ")
Snacks.toggle.dim():map("<leader>uz")
Snacks.toggle.indent():map("<leader>ui")

Snacks.toggle({
  name = "Buffer Diagnostics",
  get = function()
    return vim.diagnostic.is_enabled { bufnr = 0 }
  end,
  set = function(_)
    vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = 0 }, { bufnr = 0 })
  end,
}):map("<leader>ud")

Snacks.toggle({
  name = "Buffer Format",
  get = function()
    return not vim.b[0].disable_autoformat
  end,
  set = function(_)
    vim.b[0].disable_autoformat = not vim.b[0].disable_autoformat
  end,
}):map("<leader>uf")

Snacks.toggle({
  name = "Global Format",
  get = function()
    return not vim.g.disable_autoformat
  end,
  set = function(_)
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end,
}):map("<leader>uF")

Snacks.toggle({
  name = "Completion Menu",
  get = function()
    return vim.b.completion ~= false
  end,
  set = function(state)
    vim.b.completion = state
  end,
}):map("<leader>um")

Snacks.toggle({
  name = "Git Blame Line",
  get = function()
    return require("gitsigns.config").config.current_line_blame
  end,
  set = function(_)
    require("gitsigns").toggle_current_line_blame()
  end,
}):map("<leader>ub")

Snacks.toggle({
  name = "Git Deleted",
  get = function()
    return require("gitsigns.config").config.show_deleted
  end,
  set = function(_)
    require("gitsigns").preview_hunk_inline()
  end,
}):map("<leader>ug")

Snacks.toggle({
  name = "Hardtime",
  get = function()
    return not vim.g.hardtime_enabled
  end,
  set = function()
    vim.g.hardtime_enabled = not vim.g.hardtime_enabled
    vim.cmd("Hardtime toggle")
  end,
}):map("<leader>uH")
