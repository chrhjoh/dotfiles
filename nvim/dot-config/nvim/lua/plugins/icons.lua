return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
    config = function(_, opts)
      local palette = require("catppuccin.palettes").get_palette("mocha")
      local devicons = require("nvim-web-devicons")
      devicons.setup(opts)
      devicons.set_icon {
        snakemake = {
          icon = "󱔎",
          color = palette.green,
          name = "Snakemake",
        },
      }
      devicons.set_icon_by_filetype {
        snakemake = "snakemake",
      }
    end,
  },
  { "echasnovski/mini.icons", version = false, lazy = true, opts = {} },
}
