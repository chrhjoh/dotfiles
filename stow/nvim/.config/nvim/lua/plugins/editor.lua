local todo_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Todo" }

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-cmdline",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",

      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup {}

      cmp.setup {
        window = { completion = { scrolloff = 1 }, documentation = { max_height = 20 * 20 / vim.o.lines } },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<Down>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-c>"] = cmp.mapping.complete { reason = cmp.ContextReason.Auto },
          ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<S-cr>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = require("cmp.types").cmp.SelectBehavior.Select }
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = require("cmp.types").cmp.SelectBehavior.Select }
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "path", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          {
            name = "spell",
            group_index = 3,
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
            },
          },
          { name = "buffer", group_index = 5 },
        },
        formatting = {
          format = function(entry, item)
            local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
            item = require("lspkind").cmp_format {
              mode = "symbol_text",
            }(entry, item)
            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = color_item.abbr
            end
            return item
          end,
        },
      }
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
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
          "bash",
          "markdown",
          "markdown_inline",
          "julia",
          "snakemake",
          "json",
          "toml",
          "gitcommit",
          "yaml",
          "regex",
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
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>a"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
}
