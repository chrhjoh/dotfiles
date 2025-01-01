-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Automatic reselect after indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>yP', ':let @* = expand("%:p")<CR>', { desc = 'Yank Absolute [P]athy' })
vim.keymap.set('n', '<leader>yp', ':let @* = expand("%")<CR>', { desc = 'Yank Relative [P]ath' })
vim.keymap.set('n', '<leader>y.', ':let @* = expand("%:t")<CR>', { desc = 'Yank Filename' })
vim.keymap.set('n', '<leader>p', '"0p<cr>', { desc = 'Put from last yank registry' })
vim.keymap.set('n', '<leader>P', '<CMD>YankyRingHistory<CR>', { desc = 'Put from yank history' })

-- Moving between buffers
vim.keymap.set('n', '<TAB>', ':bn<CR>', { desc = 'Next Buffer', silent = true })
vim.keymap.set('n', '<S-TAB>', ':bp<CR>', { desc = 'Previous Buffer', silent = true })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bo', function()
  Snacks.bufdelete { other = true }
end, { desc = 'Delete all other buffers' })
vim.keymap.set(
  'n',
  '<leader>bc',
  "<cmd>let @+ = expand('%:p')<cr>",
  { desc = 'Copy current buffer relative path to clipboard' }
)

-- Moving over quickfix items quickly
vim.keymap.set('n', '<C-n>', ':cn<CR>', { desc = 'Next item in list', silent = true })
vim.keymap.set('n', '<C-p>', ':cp<CR>', { desc = 'Previous item in list', silent = true })

-- Save file
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- Lists
local window_is_open = function(variable)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value('buftype', { buf = buf }) == variable then
      return true
    end
  end
  return false
end
vim.keymap.set('n', '<leader>ll', function()
  if window_is_open('location') then
    vim.cmd('lclose')
  else
    vim.cmd('lopen')
  end
end, { desc = 'Toggle Quickfix List' })

vim.keymap.set('n', '<leader>lq', function()
  if window_is_open('quickfix') then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end, { desc = 'Toggle Location List' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

vim.keymap.set('n', '<leader>ww', '<C-W>p', { desc = 'Other Window', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
vim.keymap.set('n', '<leader>q', '<cmd>close<cr>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>Q', '<cmd>quit<cr>', { desc = 'Quit Neovim' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- new file
vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Move around
vim.keymap.set('i', '<c-l>', '<right>', { desc = 'Right' })
vim.keymap.set('i', '<c-k>', '<up>', { desc = 'Up' })
vim.keymap.set('i', '<c-j>', '<down>', { desc = 'Down' })
vim.keymap.set('i', '<c-h>', '<left>', { desc = 'Left' })

vim.keymap.set(
  { 'v', 'n' },
  '<leader>tp',
  '<cmd>PasteSelectionWezPane<cr>',
  { desc = 'Paste Selection to selected WezTerm pane' }
)
vim.keymap.set('n', '<leader>tP', '<cmd>SelectWezPane<cr>', { desc = 'Select WezTerm pane for pasting' })

vim.keymap.set('n', '<leader>X', '<cmd>source % <CR>', { desc = 'Source current Lua file' })
vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Source current Lua line' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Source current Lua selection' })
