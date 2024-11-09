return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "catppuccin-mocha"
    require("catppuccin").setup({
      integrations = {
        fidget = true,
        noice = true,
        notify = true,
      }
    })
  end,
}
