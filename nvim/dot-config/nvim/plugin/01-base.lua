vim.pack.add {
  { src = "https://github.com/rose-pine/neovim",     version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.icons", version = "main" },
}
-- require("catppuccin").setup { auto_integrations = false, default_integrations = true, transparent_background = true }
require("rose-pine").setup { styles = { transparency = true } }
vim.cmd.colorscheme("rose-pine")

require("mini.icons").setup()
