return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = "markdown",

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  opts = {},
  keys = {
    { "<localleader>mt", "<cmd>Markview toggle<cr>",       desc = "Markview Toggle" },
    { "<localleader>ms", "<cmd>Markview splitToggle<cr>",  desc = "Markview Split Toggle" },
    { "<localleader>mh", "<cmd>Markview hybridToggle<cr>", desc = "Markview hybrid Toggle" }


  }
}
