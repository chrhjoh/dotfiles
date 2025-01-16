local yank_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Yanky" }
local snacks_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Snacks" }
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
          { "<leader>n", desc = "+noice" },

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
    keys = function()
      return yank_map {
        {
          "y",
          "<Plug>(YankyYank)",
          mode = { "n", "x" },
          desc = "Yank Text",
        },
        {
          "p",
          "<Plug>(YankyPutAfter)",
          mode = { "n", "x" },
          desc = "Put Yanked Text After Cursor",
        },
        {
          "P",
          "<Plug>(YankyPutBefore)",
          mode = { "n", "x" },
          desc = "Put Yanked Text Before Cursor",
        },
        {
          "gp",
          "<Plug>(YankyGPutAfter)",
          mode = { "n", "x" },
          desc = "Put Yanked Text After Selection",
        },
        {
          "gP",
          "<Plug>(YankyGPutBefore)",
          mode = { "n", "x" },
          desc = "Put Yanked Text Before Selection",
        },
        { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
        { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
        { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
        { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
        { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
        { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
        { "<leader>P", "<CMD>YankyRingHistory<CR>", desc = "Put from yank history" },
        { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
      }
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      quickfile = { enabled = true },
      input = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      scroll = { enabled = true },
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
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
    keys = function(keys)
      return vim.list_extend(
        keys,
        snacks_keymap {
          {
            "]]",
            function()
              Snacks.words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
          },
          {
            "[[",
            function()
              Snacks.words.jump(-vim.v.count1)
            end,
            desc = "Prev Reference",
            mode = { "n", "t" },
          },
          {
            "<leader>gb",
            function()
              Snacks.git.blame_line()
            end,
            desc = "Git Blame Line",
          },
          {
            "<leader>gB",
            function()
              Snacks.gitbrowse()
            end,
            desc = "Git Browse",
          },
          {
            "<leader>cR",
            function()
              Snacks.rename.rename_file()
            end,
            desc = "Rename File",
          },
        }
      )
    end,
  },
}
