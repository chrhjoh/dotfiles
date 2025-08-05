return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    version = "*",
    priority = 1000,
    opts = {
      transparent_background = true,
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
    },
    opts = function()
      local keypress_component = {
        "%S",
      }
      -- Theme
      return {
        options = {
          section_separators = "",
          component_separators = "|",
          disabled_filetypes = { "snacks_dashboard", "neo-tree" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {},
          lualine_b = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            "filename",
          },
          lualine_c = {
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = Utils.icons.diagnostics,
              separator = "",
            },
          },
          lualine_x = {
            keypress_component,
          },
          lualine_y = {},
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
