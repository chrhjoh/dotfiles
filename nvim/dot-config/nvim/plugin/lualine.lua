vim.pack.add {
  { src = "https://github.com/bwpge/lualine-pretty-path", version = "main" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },
}

Core.loader.load_eager_if_arg(function()
  require("mini.icons").mock_nvim_web_devicons()
  local gruvbox_theme = require("lualine.themes.gruvbox")
  local gruvbox = require("gruvbox")

  gruvbox_theme.normal.c.bg = gruvbox.palette.dark0_hard
  gruvbox_theme.insert.c = nil
  gruvbox_theme.visual.c = nil
  require("lualine").setup {
    options = {
      section_separators = "",
      component_separators = "|",
      disabled_filetypes = { "snacks_dashboard" },
      globalstatus = true,
      theme = gruvbox_theme,
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
          highlights = { modified = "GruvboxYellowBold" },
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
          symbols = Core.icons.diagnostics,
          separator = "",
        },
      },
      lualine_z = {},
    },
    extensions = {
      "toggleterm",
      "oil",
      "quickfix",
      require("core").utils.lualine.snacks_picker,
      require("core").utils.lualine.snacks_notifications,
      require("core").utils.lualine.sidekick,
      require("core").utils.lualine.pack,
    },
  }
end)
