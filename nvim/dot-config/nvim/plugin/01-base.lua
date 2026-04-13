vim.pack.add {
  { src = "https://github.com/catppuccin/nvim", version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.icons", version = "main" },
}
require("catppuccin").setup { auto_integrations = false, default_integrations = true }
vim.cmd.colorscheme("catppuccin-mocha")

require("mini.icons").setup()
