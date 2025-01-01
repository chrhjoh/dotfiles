return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      win_options = {},
      view_options = { show_hidden = true },
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
    keys = {
      { '-', '<CMD>Oil --float<CR>', desc = 'Open Oil buffer In Parent Directory' },
      {
        '<leader>f-',
        function()
          require('oil').open_float(vim.fn.getcwd())
        end,
        desc = 'Open Oil buffer In Root Directory',
      },
    },
  },
}
