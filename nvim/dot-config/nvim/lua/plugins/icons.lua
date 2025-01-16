return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
    config = function(_, opts)
      local devicons = require("nvim-web-devicons")
      devicons.setup(opts)
      devicons.set_icon {
        snakemake = {
          icon = "󱔎",
          color = "#a6e3a1",
          name = "Snakemake",
        },
      }
      devicons.set_icon_by_filetype {
        snakemake = "snakemake",
      }
    end,
  },
  { "echasnovski/mini.icons", version = false, lazy = true },
}
