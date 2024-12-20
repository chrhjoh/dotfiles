local move_mux = function(direction)
  if vim.env.TMUX then
    if direction == 'h' then
      vim.cmd('TmuxNavigateLeft')
    end
    if direction == 'j' then
      vim.cmd('TmuxNavigateDown')
    end
    if direction == 'k' then
      vim.cmd('TmuxNavigateUp')
    end
    if direction == 'l' then
      vim.cmd('TmuxNavigateRight')
    end
  end
  require('wezterm-move').move(direction)
end

vim.keymap.set('n', '<C-h>', function()
  move_mux('h')
end, { desc = 'Move Pane Left' })
vim.keymap.set('n', '<C-j>', function()
  move_mux('j')
end, { desc = 'Move Pane Down' })
vim.keymap.set('n', '<C-k>', function()
  move_mux('k')
end, { desc = 'Move Pane Up' })
vim.keymap.set('n', '<C-l>', function()
  move_mux('l')
end, { desc = 'Move Pane Right' })

return {
  { 'letieu/wezterm-move.nvim', lazy = true },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
  },
}
