return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  -- See `:help lualine.txt`
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'catppuccin',
        section_separators = '',
        component_separators = '|',
        disabled_filetypes = { 'snacks_dashboard', 'neo-tree' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', sections = { 'error', 'warn' } } },
        lualine_c = {
          {
            'filename'
          }
        },
        lualine_x = {
          { 'copilot', show_colors = true },
          'filetype'
        },
        lualine_y = {
          { "aerial", colored = true, depth = -1 },
          'progress',

        },
        lualine_z = { 'location' },
      }
    }
  end
}
