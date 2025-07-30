return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = { blink_cmp = true, grug_far = true, which_key = true, snacks = true, markview = true },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-macchiato")
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
        separator = "",
      }
      -- Theme
      local macchiato = require("catppuccin.palettes").get_palette("macchiato")
      return {
        options = {
          section_separators = "",
          component_separators = "|",
          disabled_filetypes = { "snacks_dashboard", "neo-tree" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
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
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              "filename",
              path = 1,
              symbols = { modified = " ", readonly = " 󰌾 ", newfile = " " },
              color = function(section)
                return vim.bo.modified and { fg = macchiato.yellow, gui = "italic,bold" } or nil
              end,
            },
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = Utils.icons.diagnostics,
            },
          },
          lualine_x = {
            keypress_component,
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function()
                return { fg = Snacks.util.color("Special") }
              end,
            },
          },
          lualine_y = {
            "progress",
          },
          lualine_z = { "location" },
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
