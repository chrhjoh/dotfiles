return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override_by_filename = {
        ["snakefile"] = {
          icon = "󱔎",
          color = "#a6e3a1",
          name = "Snakemake",
        },
      },
      override_by_extention = {
        ["smk"] = {
          icon = "󱔎",
          color = "#a6e3a1",
          name = "Snakemake",
        },
      },
    },
  },
  { "echasnovski/mini.icons", version = false, lazy = true },
}
