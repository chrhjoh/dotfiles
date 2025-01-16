local todo_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Todo" }

return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = "rafamadriz/friendly-snippets",
    build = function(blink)
      require("blink.cmp.fuzzy.download").from_github(blink.tag) -- forces a blocking install
    end,
    event = "InsertEnter",
    opts = {
      fuzzy = { prebuilt_binaries = { download = false } }, -- Already fetched in built
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
      completion = {
        menu = {
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = { enabled = false },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<S-CR>"] = { "select_and_accept", "show", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        cmdline = {
          preset = "default",
          ["<S-CR>"] = { "select_and_accept", "fallback" },
          ["<C-y>"] = { "select_and_accept", "show" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufNewFile", "BufReadPost", "BufWritePre" },
    opts = {},
    config = function(opts)
      require("Comment").setup(opts)
      vim.keymap.del("n", "gc")
      vim.keymap.del("n", "gb")
      local wk = require("which-key")
      wk.add {
        { "gb", group = "Comment: Toggle Blockwise" },
        { "gc", group = "Comment: Toggle Linewise" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
    keys = function()
      return todo_keymap {
        {
          "]t",
          function()
            require("todo-comments").jump_next()
          end,
          desc = "Next Todo Comment",
        },
        {
          "[t",
          function()
            require("todo-comments").jump_prev()
          end,
          desc = "Previous Todo Comment",
        },
        {
          "<leader>st",
          function()
            Snacks.picker.todo_comments()
          end,
          desc = "Todo",
        },
        {
          "<leader>sT",
          function()
            Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME" } }
          end,
          desc = "Todo/Fix/Fixme",
        },
      }
    end,
  },
  --Tabwidth etc.
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
