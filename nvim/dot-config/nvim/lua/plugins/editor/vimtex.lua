return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'skim'
    vim.g.tex_conceal = 'abdmg'
  end,
}