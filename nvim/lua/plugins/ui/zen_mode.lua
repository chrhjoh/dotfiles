return {
  'folke/zen-mode.nvim',
  lazy = true,
  cmd = 'ZenMode',
  opts = {
    window = {
      backdrop = 1,
      width = 0.85,
    },
    plugins = {
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = '+4', -- (10% increase per step)
      },
    },
  },
}
