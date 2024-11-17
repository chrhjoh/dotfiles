return {
  "olimorris/persisted.nvim",
  lazy = true,
  cmd = "SessionSelect",
  config = function()
    require('persisted').setup({
      use_git_branch = true,
      autostart = false,
      autoload = false
    })
  end,

}
