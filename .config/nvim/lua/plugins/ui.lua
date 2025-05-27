local noice_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Noice" }
local trouble_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Trouble" }
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = { cmp = true, grug_far = true, which_key = true, snacks = true, markview = true },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      statuscolumn = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { pane = 1, section = "header" },
          { pane = 1, section = "keys", gap = 1, padding = 1 },
          {
            icon = " ",
            key = "p",
            desc = "Projects",
            action = ":lua Snacks.picker.projects()",
          },

          { pane = 2, padding = 8 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },

          { section = "startup" },
        },
      },
      indent = { enabled = true },
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
    --stylua: ignore
    keys = function()
      return noice_map {
        { "<c-Enter>",  function()   require("noice").redirect(vim.fn.getcmdline()) end,                        desc = "Redirect Cmdline",  mode = "c"},
        { "<leader>nl", function()   require("noice").cmd("last") end,                                          desc = "Noice Last Message",},
        { "<leader>na", function()   require("noice").cmd("all") end,                                           desc = "Noice All",},
        { "<leader>N",  function()   require("noice").cmd("all") end,                                           desc = "Noice All",},
        { "<leader>nd", function()   require("noice").cmd("dismiss") end,                                       desc = "Dismiss All",},
        { "<leader>sn", function()   require("noice").cmd("pick") end,                                          desc = "Search",},
        { "<c-f>",      function()   if not require("noice.lsp").scroll(4) then     return "<c-f>"   end end,   desc = "Scroll Forward",    mode = { "i", "n", "s" },  silent = true, expr = true, },
        { "<c-b>",      function()   if not require("noice.lsp").scroll(-4) then     return "<c-b>"   end end,  desc = "Scroll Backward",   mode = { "i", "n", "s" }, silent = true, expr = true, },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
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
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = Utils.icons.diagnostics,
            },
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
        extensions = { "lazy", "fzf", "toggleterm", "oil", "quickfix" },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
    --stylua: ignore
    keys = function()
      return trouble_map {
        { "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>",                      desc = "Diagnostics" },
        { "<leader>lD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",         desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>cy", "<cmd>Trouble symbols toggle<cr>",                          desc = "Symbols" },
        { "<leader>cY", "<cmd>Trouble lsp toggle<cr>",                              desc = "LSP references/definitions/... (Trouble)",},
        { "<leader>lL", "<cmd>Trouble loclist toggle<cr>",                          desc = "Location List" },
        { "<leader>lQ", "<cmd>Trouble qflist toggle<cr>",                           desc = "Quickfix List " },
        { "<leader>lf", "<cmd>Trouble snacks_files toggle<cr>",                     desc = "Snacks Files" },
        {"<leader>lt",  function() require("trouble").toggle { mode = "todo" } end, desc = "Todo",
        },
        {
          "<leader>lT",
          function()
            require("trouble").toggle { mode = "todo", filter = { { tag = { "TODO", "FIX", "FIXME" } } } }
          end,
          desc = "Todo/Fix/Fixme",
        },
      }
    end,
  },
}
