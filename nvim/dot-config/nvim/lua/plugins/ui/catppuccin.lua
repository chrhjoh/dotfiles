return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      integrations = { blink_cmp = true, cmp = false, grug_far = true, which_key = true },
      highlight_overrides = {
        all = function(colors)
          return {
            PmenuSel = { bg = colors.blue, fg = colors.base },
          }
        end,
      },
    }
    vim.cmd.colorscheme('catppuccin-mocha')
  end,
}
