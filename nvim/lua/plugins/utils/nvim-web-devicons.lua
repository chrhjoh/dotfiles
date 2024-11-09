return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").set_icon({
        ['snakefile'] = {
          icon = "󱔎",
          color = "#a6e3a1",
          name = "Snakemake"
        },
        ['smk'] = {
          icon = "󱔎",
          color = "#a6e3a1",
          name = "Snakemake"
        }
      })
    end


  }
}
