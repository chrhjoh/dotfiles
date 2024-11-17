return {
  'tummetott/unimpaired.nvim',
  event = 'VeryLazy',
  opts = {
    default_keymaps = false,
    keymaps = {
      blank_above = {
        mapping = '[<Space>',
        description = 'Add [count] blank lines above',
        dot_repeat = true,
      },
      blank_below = {
        mapping = ']<Space>',
        description = 'Add [count] blank lines below',
        dot_repeat = true,
      },
      exchange_above = {
        mapping = '[E',
        description = 'Exchange line with [count] lines above',
        dot_repeat = true,
      },
      exchange_below = {
        mapping = ']E',
        description = 'Exchange line with [count] lines below',
        dot_repeat = true,
      },
      exchange_section_above = {
        mapping = '[E',
        description = 'Move section [count] lines up',
        dot_repeat = true,
      },
      exchange_section_below = {
        mapping = ']E',
        description = 'Move section [count] lines down',
        dot_repeat = true,
      },
    },
  }
}
