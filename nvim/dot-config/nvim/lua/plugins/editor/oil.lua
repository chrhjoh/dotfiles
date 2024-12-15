-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require('oil').get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
      },
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
      keymaps = {
        ['<localleader>o?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<localleader>o-'] = {
          'actions.select',
          opts = { vertical = true },
          desc = 'Open the entry in a vertical split',
        },
        ['<localleader>o|'] = {
          'actions.select',
          opts = { horizontal = true },
          desc = 'Open the entry in a horizontal split',
        },
        ['<localleader>op'] = { 'actions.preview', desc = 'Preview File/Folder' },
        ['q'] = 'actions.close',
        ['<C-c>'] = 'actions.close',
        ['<localleader>oc'] = { 'actions.close', desc = 'Close Oil' },
        ['<C-s>'] = false,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
        ['<localleader>os'] = { 'actions.change_sort', desc = 'Change Sort' },
        ['<localleader>ox'] = { 'actions.open_external', desc = 'Open With External Program' },
        ['<localleader>o.'] = { 'actions.toggle_hidden', desc = 'Toggle Hidden' },
        ['<localleader>ot'] = { 'actions.toggle_trash', desc = 'toggle Trash' },
        ['<localleader>oD'] = {
          function()
            require('oil').discard_all_changes()
          end,
          desc = 'Discard All Changes',
        },
        ['<loacalleader>or'] = { 'actions.refresh', desc = 'Refresh' },
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
    keys = {
      { '<leader>E', '<CMD>Oil<CR>', desc = 'Open Oil In Parent Directory' },
      { '<leader>fE', '<CMD>Oil<CR>', desc = 'Open Oil In Parent Directory' },
    },
  },
}
