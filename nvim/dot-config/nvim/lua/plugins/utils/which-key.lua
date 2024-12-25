return {
  'folke/which-key.nvim',
  opts = {
    preset = 'classic',
    icons = {
      separator = '→',
    },
    spec = {
      {
        mode = { 'n', 'v' },
        {
          '<leader>b',
          group = 'buffers',
          expand = function()
            return require('which-key.extras').expand.buf()
          end,
        },
        { '<leader>c', group = 'code' },
        { '<leader>D', group = 'debug' },
        { '<leader>l', group = 'lists' },
        { '<leader>f', group = 'files' },
        { '<leader>g', group = 'git' },
        { '<leader>r', group = 'refactors' },
        { '<leader>s', group = 'searches' },
        { '<leader>t', group = 'terminals' },
        { '<leader>u', group = 'toggles' },
        { '<leader>w', group = 'windows', proxy = '<c-w>' },
        { '<leader>y', group = 'yanks' },
        { '<leader>q', group = 'sessions' },

        { '<localleader>o', group = 'oil' },
        { '<localleader>l', group = 'latex' },
        { '<localleader>t', group = 'typst' },
        { '<localleader>m', group = 'markdown' },

        { ']', group = 'prev' },
        { '[', group = 'next' },
        { 'g', group = 'goto' },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
      },
    },
  },
}
