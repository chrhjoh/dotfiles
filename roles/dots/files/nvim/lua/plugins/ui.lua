local function custom_lualine_theme(catppuccin_pallette)
  local catppuccin = {}
  catppuccin.normal = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.blue, gui = "bold" },
    b = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.lavender },
    c = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.text },
  }

  catppuccin.insert = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.green, gui = "bold" },
  }

  catppuccin.terminal = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.green, gui = "bold" },
  }

  catppuccin.command = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.peach, gui = "bold" },
  }

  catppuccin.visual = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.mauve, gui = "bold" },
  }

  catppuccin.replace = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.red, gui = "bold" },
  }

  catppuccin.inactive = {
    a = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.blue },
    b = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.surface1, gui = "bold" },
    c = { bg = catppuccin_pallette.base, fg = catppuccin_pallette.overlay0 },
  }

  return catppuccin
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    version = "*",
    priority = 1000,
    opts = {
      auto_integrations = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.icons",
      "bwpge/lualine-pretty-path",
    },
    opts = function()
      local keypress_component = {
        "%S",
        separator = false,
      }
      local palette = require("catppuccin.palettes").get_palette("mocha")

      return {
        options = {
          theme = custom_lualine_theme(palette),
          section_separators = "",
          component_separators = "|",
          disabled_filetypes = { "snacks_dashboard" },
          globalstatus = true,
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
            keypress_component,
            "filetype",
          },
          lualine_y = {
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = Utils.icons.diagnostics,
              separator = "",
            },
          },
          lualine_z = {},
        },
        extensions = { "lazy", "fzf", "toggleterm", "oil", "quickfix" },
      }
    end,
    config = function(_, opts)
      require("mini.icons").mock_nvim_web_devicons()
      require("lualine").setup(opts)
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      ---Highlight hex colors, e.g. '#FFFFFF'
      enable_hex = true,

      ---Highlight short hex colors e.g. '#fff'
      enable_short_hex = false,

      ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
      enable_rgb = true,

      ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
      enable_hsl = true,

      ---Highlight CSS variables, e.g. 'var(--testing-color)'
      enable_var_usage = true,

      ---Highlight named colors, e.g. 'green'
      enable_named_colors = true,

      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = false,
    },
  },
}
