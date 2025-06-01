local yank_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Yanky" }
local snacks_keymap = Utils.keymap.get_mapper { mode = "n", desc_prefix = "Snacks" }
local snacks_lazy_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Snacks" }
local oil_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Oil" }
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@class wk.Opts
    opts = {
      preset = "helix",
      icons = {
        separator = "→",
        rules = {
          { pattern = "put", icon = "󰅇 ", color = "yellow" },
          { pattern = "yank", icon = "󰅇 ", color = "yellow" },
          { pattern = "lists", icon = " ", color = "green" },
          { pattern = "lua", icon = "󰢱 ", color = "blue" },
          { pattern = "obsidian", icon = " ", color = "purple" },
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
          { "<leader>l", group = "lists" },
          { "<leader>f", group = "files" },
          { "<leader>g", group = "git" },
          { "<leader>s", group = "searches" },
          { "<leader>t", group = "terminals" },
          { "<leader>u", group = "toggles" },
          { "<leader>w", group = "windows", proxy = "<c-w>" },
          { "<leader>y", group = "yank" },
          { "<leader>d", desc = "debug" },
          { "<leader>q", desc = "sessions" },
          { "<leader>n", desc = "noice" },
          { "<leader>o", desc = "obsidian" },

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
    "gbprod/yanky.nvim",
    opts = {
      highlight = {
        on_put = false,
        on_yank = false,
      },
    },
    --stylua: ignore
    keys = function()
      return yank_map {
        { "y",          "<Plug>(YankyYank)",                      desc = "Yank Text",                         mode = {"n", "x"}},
        { "p",          "<Plug>(YankyPutAfter)",                  desc = "Put Yanked Text After Cursor",      mode = {"n", "x"}},
        { "P",          "<Plug>(YankyPutBefore)",                 desc = "Put Yanked Text Before Cursor",     mode = {"n", "x"}},
        { "gp",         "<Plug>(YankyGPutAfter)",                 desc = "Put Yanked Text After Selection",   mode = {"n", "x"}},
        { "gP",         "<Plug>(YankyGPutBefore)",                desc = "Put Yanked Text Before Selection",  mode = {"n", "x"}},
        { "[y",         "<Plug>(YankyCycleForward)",              desc = "Cycle Forward Through Yank History" },
        { "]y",         "<Plug>(YankyCycleBackward)",             desc = "Cycle Backward Through Yank History" },
        { "]p",         "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put Indented After Cursor (Linewise)" },
        { "[p",         "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put Indented Before Cursor (Linewise)" },
        { "]P",         "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put Indented After Cursor (Linewise)" },
        { "[P",         "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put Indented Before Cursor (Linewise)" },
        { ">p",         "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and Indent Right" },
        { "<p",         "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and Indent Left" },
        { ">P",         "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
        { "<P",         "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put Before and Indent Left" },
        { "<leader>sy",  "<CMD>YankyRingHistory<CR>",              desc = "Search yank history" },
      }
    end,
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
        }
      )
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },
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
          require("trouble").open { mode = "quickfix", refresh = true, new = false }
        end,
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-p>"] = { "actions.preview" },
        ["gd"] = function()
          require("oil").set_columns { "icon", "permissions", "size", "mtime" }
        end,
        ["<leader>ff"] = {
          function()
            Snacks.picker.files {
              cwd = require("oil").get_current_dir(),
            }
          end,
          mode = "n",
          nowait = true,
          desc = "Find files in the current directory",
        },
      },
    },
    --stylua: ignore
    keys = function()
      return oil_map {
        {  "=",  function()    require("oil").open()  end,              desc = "Open Oil buffer In Parent Directory",},
        {  "<leader>=",  function()    require("oil").open(Utils.root())  end,  desc = "Open Oil buffer In Root Directory",},
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "gonstoll/wezterm-types" },
    opts = {
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- "${3rd}/busted/library",
      },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}
