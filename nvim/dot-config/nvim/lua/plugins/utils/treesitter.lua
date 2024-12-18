return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },
  },
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      -- add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'lua',
        'python',
        'rust',
        'vimdoc',
        'vim',
        'bash',
        'markdown',
        'markdown_inline',
        'julia',
        'snakemake',
        'json',
        'toml',
        'gitcommit',
        'yaml',
        'nix',
      },

      -- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
      auto_install = false,
      -- install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- list of parsers to ignore installing
      ignore_install = {},
      -- you can specify additional treesitter modules here: -- for example: -- playground = {--enable = true,-- },
      modules = {},
      highlight = { enable = true, disable = { 'latex' } },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<m-space>',
          node_incremental = '<m-space>',
          scope_incremental = '<m-s>',
          node_decremental = '<m-b>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- you can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']}'] = '@class.outer',
          },
          goto_next_end = {
            [']m'] = '@function.outer',
            [']{'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[{'] = '@class.outer',
          },
          goto_previous_end = {
            ['[m'] = '@function.outer',
            ['[}'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>a'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}
