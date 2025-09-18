local snacks_keymap = Utils.keymap.get_mapper { mode = "n", desc_prefix = "Snacks" }
local snacks_lazy_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Snacks" }
local oil_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Oil" }
local detail = false
return {
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@class wk.Opts
    opts = {
      preset = "helix",
      icons = {
        separator = "→",
        rules = {
          { pattern = "yank", icon = "󰅇 ", color = "yellow" },
          { pattern = "message", icon = "󰆈 ", color = "gray" },
          { pattern = "lua", icon = "󰢱 ", color = "blue" },
        },
      },
      spec = {
        {
          mode = { "n", "v" },
          {
            "<leader>b",
            group = "buffers",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "files" },
          { "<leader>g", group = "git" },
          { "<leader>o", desc = "obsidian" },
          { "<leader>q", desc = "sessions" },
          { "<leader>s", group = "searches" },
          { "<leader>t", group = "terminals" },
          { "<leader>u", group = "toggles" },
          { "<leader>y", group = "yank" },
          { "<leader>w", group = "windows", proxy = "<c-w>" },
          { "<leader>A", desc = "AI" },

          { "<localleader>l", group = "latex" },
          { "<localleader>t", group = "typst" },
          { "<localleader>m", group = "markdown" },

          { "]", group = "prev" },
          { "[", group = "next" },
          { "g", group = "goto" },
          { "z", group = "fold" },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      quickfile = { enabled = true },
      input = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      scroll = { enabled = true },
      image = {
        enabled = true,
        math = {
          latex = {
            font_size = "small",
          },
        },
      },
      statuscolumn = { enabled = true },
      indent = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 2 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
          { section = "startup" },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim._print = function(_, ...)
            _G.dd(...)
          end
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          --stylua: ignore start
          snacks_keymap { "]]", function()  Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",  buffer = buffer,}
          snacks_keymap { "[[", function()  Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",  buffer = buffer,}
          --stylua: ignore end
        end,
      })
    end,
    --stylua: ignore
    keys = function(keys)
      return vim.list_extend(
        keys,
        snacks_lazy_keymap {
          {  "]]",          function()    Snacks.words.jump(vim.v.count1)  end,   desc = "Next Reference",  mode = { "n", "t" },},
          {  "[[",          function()    Snacks.words.jump(-vim.v.count1)  end,  desc = "Prev Reference",  mode = { "n", "t" },},
          {  "<leader>gb",  function()    Snacks.git.blame_line()  end,           desc = "Git Blame Line",},
          {  "<leader>gB",  function()    Snacks.gitbrowse()  end,                desc = "Git Browse",},
          {  "<leader>cR",  function()    Snacks.rename.rename_file()  end,       desc = "Rename File",},
          {  "<leader>n",  function()    Snacks.notifier.show_history()  end,       desc = "Notifications",},
        }
      )
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      columns = {
        "icon",
        -- "permissions",
        --'size',
        --'mtime',
      },
      win_options = {},
      view_options = { show_hidden = true },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 3000,
        autosave_changes = "unmodified",
      },
      preview_win = {
        preview_method = "load",
        disable_preview = function(filename)
          return filename == "../"
        end,
      },
      keymaps = {
        ["<C-s>"] = false,
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["q"] = { "actions.close", mode = "n" },
        ["<Tab>"] = function()
          require("oil.actions").send_to_qflist.callback()
        end,
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-p>"] = { "actions.preview" },

        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns { "icon", "permissions", "size", "mtime" }
            else
              require("oil").set_columns { "icon" }
            end
          end,
        },
        ["<leader>sg"] = {
          function()
            Snacks.picker.grep {
              cwd = require("oil").get_current_dir(),
            }
          end,
          mode = "n",
          nowait = true,
          desc = "Grep files in Oil directory",
        },
        ["<leader>ff"] = {
          function()
            Snacks.picker.files {
              cwd = require("oil").get_current_dir(),
            }
          end,
          mode = "n",
          nowait = true,
          desc = "Find files in the Oil directory",
        },
      },
    },
    --stylua: ignore
    keys = function()
      return oil_map {
        {  "<leader>e",  function()    require("oil").open()  end,              desc = "Open Oil buffer In Parent Directory",},
        {  "<leader>E",  function()    require("oil").open(Utils.root())  end,  desc = "Open Oil buffer In Root Directory",},
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.hardtime_enabled = false
    end,
    opts = { enabled = false },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
