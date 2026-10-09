vim.pack.add {
  { src = "https://github.com/ellisonleao/gruvbox.nvim", version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.icons", version = "main" },
}

local material_palette = {
  dark0_hard = "#1d2021",
  dark0 = "#282828",
  dark0_soft = "#32302f",
  dark1 = "#3c3836",
  dark2 = "#504945",
  dark3 = "#665c54",
  dark4 = "#7c6f64",

  light0_hard = "#f9f5d7",
  light0 = "#fbf1c7",
  light0_soft = "#f2e5bc",
  light1 = "#ebdbb2",
  light2 = "#d5c4a1",
  light3 = "#a89984",
  light4 = "#7c6f64",

  bright_red = "#ea6962",
  bright_green = "#a9b665",
  bright_yellow = "#d8a657",
  bright_blue = "#7daea3",
  bright_purple = "#d3869b",
  bright_aqua = "#89b482",
  bright_orange = "#e78a4e",

  neutral_red = "#ea6962",
  neutral_green = "#a9b665",
  neutral_yellow = "#d8a657",
  neutral_blue = "#7daea3",
  neutral_purple = "#d3869b",
  neutral_aqua = "#89b482",
  neutral_orange = "#e78a4e",

  faded_red = "#c14a4a",
  faded_green = "#6c782e",
  faded_yellow = "#b47109",
  faded_blue = "#45707a",
  faded_purple = "#945e80",
  faded_aqua = "#4c7a5d",
  faded_orange = "#c35e0a",

  dark_red_hard = "#442e2d",
  dark_red = "#4c3432",
  dark_red_soft = "#543937",

  light_red_hard = "#f0ddc3",
  light_red = "#f1d9b5",
  light_red_soft = "#efd2b3",

  dark_green_hard = "#333e34",
  dark_green = "#3b4439",
  dark_green_soft = "#424a3e",

  light_green_hard = "#dde5c2",
  light_green = "#dee2b6",
  light_green_soft = "#d7d9ae",

  dark_aqua_hard = "#2e3b3b",
  dark_aqua = "#374141",
  dark_aqua_soft = "#404946",

  light_aqua_hard = "#d9e1cc",
  light_aqua = "#dadec0",
  light_aqua_soft = "#d3d5b8",

  gray = "#928374",
}
local gruvbox = require("gruvbox")
gruvbox.setup {
  transparent_mode = true,
  contrast = "hard",
  overrides = {
    StatusLine = { bg = gruvbox.palette.dark0_hard },
    NonText = { fg = gruvbox.palette.dark4 },
    CursorLine = { bg = gruvbox.palette.dark1 },
    Visual = { bg = gruvbox.palette.dark1 },
    Bold = { bold = true },
    Italic = { italic = true },
    Underline = { underline = true },
  },
  palette_overrides = material_palette,
}
vim.cmd.colorscheme("gruvbox")

require("mini.icons").setup()
