local todo_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Todo" }

return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    version = "*",
    opts = function()
      return {
        appearance = { nerd_font_variant = "normal" },
        completion = {
          list = { selection = { auto_insert = false } },
          menu = {
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
          },
        },
        keymap = {
          preset = "none",
          ["<C-y>"] = { "show", "accept" },
          ["<C-e>"] = { "cancel" },
          ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
          ["<S-Enter>"] = { "show", "accept" },

          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },

          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },
        cmdline = {
          keymap = { preset = "inherit" },
          completion = {
            menu = {
              auto_show = true,
            },
            list = { selection = { auto_insert = false } },
            ghost_text = { enabled = false },
          },
        },
      }
    end,
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
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "python",
          "rust",
          "vimdoc",
          "vim",
          "latex",
          "bash",
          "markdown",
          "markdown_inline",
          "julia",
          "snakemake",
          "json",
          "toml",
          "sql",
          "latex",
          "toml",
          "gitcommit",
          "yaml",
          "regex",
          "diff",
        },
        highlight = { enable = true },

        auto_install = false,
        sync_install = true,
        ignore_install = {},
        modules = {},
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<m-space>",
            node_incremental = "<m-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          textobjects = {
            move = {
              enable = true,
              goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
              goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
              goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
              goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>]"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>["] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
}
