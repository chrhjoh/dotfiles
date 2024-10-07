return { {
  'kaarmu/typst.vim',
  ft = 'typst',
  init = function()
    vim.g.typst_conceal = 2
  end
}, {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  version = '*',
  build = function() require 'typst-preview'.update() end,
} }
