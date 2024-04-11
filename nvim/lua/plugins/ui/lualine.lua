return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  event = 'BufEnter',
  config = function()
    require('lualine').setup {
      options = {
        theme = 'catppuccin',
        section_separators = '',
        component_separators = '|',
        disabled_filetypes = {'alpha', 'Scratch'},
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'buffers',
            symbols = {
              alternate_file = ''
            },
          }
        },
        lualine_x = {
          'encoding',
          'filetype'
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      }
    }
  end
}