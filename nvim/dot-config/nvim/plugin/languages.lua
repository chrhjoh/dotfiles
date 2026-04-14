vim.pack.add {
  { src = "https://github.com/lervag/vimtex", version = "master" },
  { src = "https://github.com/snakemake/snakemake", version = vim.version.range("*") },
  { src = "https://github.com/OXY2DEV/markview.nvim", version = vim.version.range("*") },
}
vim.g.vimtex_view_method = "skim"
vim.g.tex_conceal = "abdmg"

Config.load.load_later(function()
  require("markview").setup {
    preview = {
      modes = { "i", "n", "no", "c" },
      hybrid_modes = { "i" },
      linewise_hybrid_mode = true,

      filetypes = { "markdown" },
      icon_provider = "mini",
    },
    markdown = { horizontal_rules = require("markview.presets").horizontal_rules.thick }, ---@diagnostic disable-line: missing-fields
  }
  vim.opt.rtp:append(Config.utils.plugin_dir("snakemake") .. "/misc/vim")
end)
