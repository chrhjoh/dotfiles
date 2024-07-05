-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>xe", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>xd", function()
  vim.diagnostic.setloclist({ severity = { min = vim.diagnostic.severity.WARN } })
end, { desc = "Open diagnostics list" })

-- Automatic reselect after indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "yP", ':let @* = expand("%:p")<CR>', { desc = "[P] Copy Absolute [P]athy" })
vim.keymap.set("n", "yp", ':let @* = expand("%")<CR>', { desc = "[p] Copy Relative [P]ath" })
vim.keymap.set("n", "y.", ':let @* = expand("%:t")<CR>', { desc = "[.] Copy Filename" })

-- Moving between buffers
vim.keymap.set("n", "<TAB>", ":bn<CR>", { desc = "Next Buffer", silent = true })
vim.keymap.set("n", "<S-TAB>", ":bp<CR>", { desc = "Previous Buffer", silent = true })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bo", ':%bdelete|edit #|bd #"<cr>', { desc = "Delete all other buffers" })
vim.keymap.set("n", "<leader>bh", ":BdeleteHigher<cr>", { desc = "Delete buffers higher than current" })
vim.keymap.set("n", "<leader>bl", ":BdeleteLower<cr>", { desc = "Delete buffers lower than current" })
vim.keymap.set("n", "<leader>bd", "<cmd>silent! bp<bar>sp<bar>silent!bn<bar>bd<cr>", { desc = "Delete Current buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>bd!<cr>", { desc = "Delete current buffer (discard changes)" })
vim.keymap.set("n", "<leader>bc", "<cmd>let @+ = expand('%:p')<cr>",
  { desc = "Copy current buffer relative path to clipboard" })


-- Moving over quickfix items quickly
vim.keymap.set("n", "<C-n>", ":cn<CR>", { desc = "Next item in list", silent = true })
vim.keymap.set("n", "<C-p>", ":cp<CR>", { desc = "Previous item in list", silent = true })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", { desc = "Close quickfix List" })
vim.keymap.set("n", "<leader>xC", "<cmd>lclose<cr>", { desc = "Close location List" })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>q", "<cmd>close<cr>", { desc = "Close current window" })
vim.keymap.set("n", "<leader>Q", "<cmd>quit<cr>", { desc = "Quit Neovim" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Terminal keybindings
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Toggles
vim.keymap.set("n", "<leader>uF", "<cmd>ToggleFormat<cr>", { desc = "Toggle auto-format globally" })
vim.keymap.set("n", "<leader>uf", "<cmd>ToggleFormat!<cr>", { desc = "Toggle auto-format for buffer" })
vim.keymap.set("n", "<leader>uc", "<cmd>ToggleGitConfigurations<cr>", { desc = "Toggle git for dotfiles" })
vim.keymap.set("n", "<leader>ud", "<cmd>ToggleDiagnostics<cr>", { desc = "Toggle diagnostics for buffer" })
