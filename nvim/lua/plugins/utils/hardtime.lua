return {
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   opts = {
      enabled = false,
      disabled_keys = {
         ["<Up>"] = { "n", "x" },
         ["<Down>"] = { "n", "x" },
         ["<Right>"] = { "n", "x" },
         ["<Left>"] = { "n", "x" },
      },
   },
   lazy = false
}
