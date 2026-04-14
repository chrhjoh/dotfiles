vim.pack.add {
  { src = "https://github.com/bwpge/lualine-pretty-path", version = "main" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },
}

Config.load.load_eager_if_arg(function()
  local palette = require("catppuccin.palettes").get_palette("mocha")
  require("mini.icons").mock_nvim_web_devicons()
  require("lualine").setup {
    options = {
      section_separators = "",
      component_separators = "|",
      disabled_filetypes = { "snacks_dashboard" },
      globalstatus = true,
      theme = {
        normal = {
          a = { bg = palette.base, fg = palette.blue, gui = "bold" },
          b = { bg = palette.base, fg = palette.lavender },
          c = { bg = palette.base, fg = palette.text },
        },
        insert = {
          a = { bg = palette.base, fg = palette.green, gui = "bold" },
        },
        terminal = {
          a = { bg = palette.base, fg = palette.green, gui = "bold" },
        },
        command = {
          a = { bg = palette.base, fg = palette.peach, gui = "bold" },
        },
        visual = {
          a = { bg = palette.base, fg = palette.mauve, gui = "bold" },
        },
        replace = {
          a = { bg = palette.base, fg = palette.red, gui = "bold" },
        },
        inactive = {
          a = { bg = palette.base, fg = palette.blue },
          b = { bg = palette.base, fg = palette.surface1, gui = "bold" },
          c = { bg = palette.base, fg = palette.overlay0 },
        },
      },
    },
    sections = {
      lualine_a = {
        "mode",
      },
      lualine_b = {
        { "branch", separator = false },
        {
          "diff",
          symbols = {
            added = " ",
            modified = " ",
            removed = " ",
          },
        },
      },
      lualine_c = {
        {
          "pretty_path",
          icon_show = false,
          symbols = {
            modified = "", -- Text to show when the file is modified.
            readonly = " ", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = " ", -- Text to show for newly created file before first write
          },
        },
      },
      lualine_x = {
        { "%S", separator = false },

        "filetype",
      },
      lualine_y = {
        {
          "diagnostics",
          sections = { "error", "warn" },
          symbols = Config.icons.diagnostics,
          separator = "",
        },
      },
      lualine_z = {},
    },
    extensions = { "toggleterm", "oil", "quickfix" },
  }
end)
