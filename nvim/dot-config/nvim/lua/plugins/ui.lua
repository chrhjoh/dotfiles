local noice_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Noice" }
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = { blink_cmp = true, cmp = false, grug_far = true, which_key = true },
    },
    config = function(opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { enabled = false },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = false },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
      },
    },
    keys = function()
      return noice_map {
        {
          "<S-Enter>",
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end,
          mode = "c",
          desc = "Redirect Cmdline",
        },
        {
          "<leader>nl",
          function()
            require("noice").cmd("last")
          end,
          desc = "Noice Last Message",
        },
        {
          "<leader>nh",
          function()
            require("noice").cmd("history")
          end,
          desc = "Noice History",
        },
        {
          "<leader>na",
          function()
            require("noice").cmd("all")
          end,
          desc = "Noice All",
        },
        {
          "<leader>nd",
          function()
            require("noice").cmd("dismiss")
          end,
          desc = "Dismiss All",
        },
        {
          "<leader>sn",
          function()
            require("noice").cmd("pick")
          end,
          desc = "Search",
        },
        {
          "<c-f>",
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end,
          silent = true,
          expr = true,
          desc = "Scroll Forward",
          mode = { "i", "n", "s" },
        },
        {
          "<c-b>",
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end,
          silent = true,
          expr = true,
          desc = "Scroll Backward",
          mode = { "i", "n", "s" },
        },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- See `:help lualine.txt`
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      --Extra components
      local recording_component = {
        function()
          ---@type string
          local text = require("noice").api.status.mode.get()
          local _, end_idx = text:find("--r")
          if end_idx ~= nil then
            text = text:sub(end_idx)
          end
          return text
        end,
        cond = function()
          if not require("noice").api.status.mode.has() then
            return false
          end
          ---@type string
          local text = require("noice").api.status.mode.get()

          return text:find("recording") ~= nil
        end,
      }
      local command_component = {
        "%S",
        separator = "",
      }
      -- Theme
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      local custom_theme = require("lualine.themes.catppuccin-mocha")
      custom_theme.normal.c.bg = mocha.base
      return {
        options = {
          theme = custom_theme,
          section_separators = "",
          component_separators = "|",
          disabled_filetypes = { "snacks_dashboard", "neo-tree" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode", recording_component },
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
                return vim.bo.modified and { fg = mocha.yellow, gui = "italic,bold" } or nil
              end,
            },
            { "diagnostics", sections = { "error", "warn" } },
          },
          lualine_x = {
            command_component,
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
        extensions = { "lazy", "fzf", "toggleterm", "oil" },
      }
    end,
  },
}
