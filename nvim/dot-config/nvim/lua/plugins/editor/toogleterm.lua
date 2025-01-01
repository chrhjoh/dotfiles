return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy = true,
  cmd = 'ToggleTerm',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      close_on_exit = false,
    }
  end,
  keys = {
    [[<c-\>]],
    {
      '<leader>tx',
      ':ToggleTermSendCurrentLine<CR>',
      desc = 'Send current line to terminal',
      mode = 'n',
    },
    {
      '<leader>tx',
      ':ToggleTermSendVisualLines<CR>',
      desc = 'Send selected lines to terminal',
      mode = 'v',
    },
    {
      '<leader>tX',
      ':ToggleTermSendVisualSelection<CR>',
      desc = 'Send selection to terminal',
      mode = 'v',
    },
    { '<leader>t|', ':ToggleTerm direction=vertical<CR>', desc = 'Open vertical terminal' },
    { '<leader>t-', ':ToggleTerm direction=horizontal<CR>', desc = 'Open horizontal terminal' },
    { '<leader>tf', ':ToggleTerm direction=float<CR>', desc = 'Open float terminal' },
  },
}
