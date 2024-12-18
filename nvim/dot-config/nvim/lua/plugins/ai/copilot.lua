return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    lazy = true,
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = '<M-y>',
            accept_word = '<M-Y>',
          },
        },
      }
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    lazy = true,
    cmd = {
      'CopilotChat',
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    config = function()
      require('CopilotChat').setup {
        mappings = {
          reset = {
            insert = '<C-c>',
            normal = '<C-c>',
          },
        },
      }
    end,
  },
}
