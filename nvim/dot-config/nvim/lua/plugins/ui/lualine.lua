local recording_component = {
  function()
    ---@type string
    local text = require('noice').api.status.mode.get()
    local _, end_idx = text:find('--r')
    if end_idx ~= nil then
      text = text:sub(end_idx)
    end
    return text
  end,
  cond = function()
    if not require('noice').api.status.mode.has() then
      return false
    end
    ---@type string
    local text = require('noice').api.status.mode.get()

    return text:find('recording') ~= nil
  end,
}
local command_component = {
  '%S',
}
return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  -- See `:help lualine.txt`
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'catppuccin',
        section_separators = '',
        component_separators = '|',
        disabled_filetypes = { 'snacks_dashboard', 'neo-tree' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode', recording_component },
        lualine_b = {
          'branch',
          'diff',
          { 'diagnostics', sections = { 'error', 'warn' } },
        },
        lualine_c = {
          {
            'filename',
          },
        },
        lualine_x = {
          command_component,
          'filetype',
        },
        lualine_y = {
          'progress',
        },
        lualine_z = { 'location' },
      },
    }
  end,
}
