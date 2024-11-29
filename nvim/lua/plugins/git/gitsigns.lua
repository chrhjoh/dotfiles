return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = "BufReadPost",
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  keys = {
    -- Navigation
    {
      ']h',
      function()
        if vim.wo.diff then
          return ']h'
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return '<Ignore>'
      end,
      expr = true,
      desc = 'Jump to next hunk',
      mode = { 'n', 'v' },

    },

    {
      '[h',
      function()
        if vim.wo.diff then
          return '[h'
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return '<Ignore>'
      end,
      expr = true,
      desc = 'Jump to previous hunk',
      mode = { 'n', 'v' },

    },

    -- Actions
    -- visual mode
    {
      '<leader>gs',
      function()
        require("gitsigns").stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end,
      desc = 'Stage git hunk',
      mode = 'v',

    },

    {
      '<leader>gr',
      function()
        require("gitsigns").reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end,
      desc = 'Reset git hunk',
      mode = 'v'
    },

    -- normal mode
    {
      '<leader>gh',
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = 'Git stage hunk',
      mode = 'n',

    },

    {
      '<leader>gr',
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = 'Git reset hunk',
      mode = 'n',

    },

    {
      '<leader>gS',
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = 'Git stage buffer',
      mode = 'n',

    },

    {
      '<leader>gu',
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      desc = 'Undo stage hunk',
      mode = 'n',

    },

    {
      '<leader>gR',
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = 'Git reset buffer',
      mode = 'n',

    },

    {
      '<leader>gp',
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = 'Preview git hunk',
      mode = 'n',

    },

    {
      '<leader>gb',
      function()
        require("gitsigns").blame_line { full = false }
      end,
      desc = 'Git blame line',
      mode = 'n',

    },

    {
      '<leader>gd',
      function()
        require("gitsigns").diffthis('~')
      end,
      desc = 'Git diff against last commit',
      mode = 'n',

    },

    {
      '<leader>gD',
      function()
        require("gitsigns").diffthis()
      end,
      desc = 'Git diff against last index',
      mode = 'n',

    },

    -- Text object
    { 'gih',        ':<C-U>Gitsigns select_hunk<CR>', desc = 'Select git hunk', mode = { 'o', 'x' } },

    -- Close git Diff
    { '<leader>gq', '<cmd>q<cr><cmd>bnext<cr>',       desc = 'Close git Diff',  mode = 'n', },
  }
}
