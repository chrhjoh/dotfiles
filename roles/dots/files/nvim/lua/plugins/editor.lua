local todo_keymap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Todo" }

return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = function()
      return {
        signature = { enabled = true },
        appearance = { nerd_font_variant = "normal" },
        completion = {
          keyword = { range = "full" },
          list = { selection = { auto_insert = false } },
          menu = {
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            },
          },
          trigger = {
            show_in_snippet = false,
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
        },
        cmdline = {
          enabled = true,
          keymap = { preset = "inherit" },
          completion = {
            menu = {
              auto_show = true,
            },
            list = { selection = { auto_insert = false } },
            ghost_text = { enabled = false },
          },
        },
        sources = {
          per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100, -- show at a higher priority than lsp
            },
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
  -- --Tabwidth etc.
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    branch = "main",
    build = function(plugin)
      local ensure_installed = {
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
        "sql",
        "latex",
        "toml",
        "gitcommit",
        "yaml",
        "regex",
        "diff",
      }
      local TS = require("nvim-treesitter")
      TS.update()
      local installed = TS.get_installed()
      local to_install = vim.tbl_filter(function(parser)
        return not vim.list_contains(installed, parser)
      end, ensure_installed)
      TS.install(to_install):wait(300000)
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if vim.list_contains(require("nvim-treesitter").get_installed(), ft) then
            vim.treesitter.start()
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      set_jumps = true,
    },
    keys = function()
      local result = {
        {
          "<leader>]",
          function()
            require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
          end,
          desc = "Swap Next Parameter",
          mode = "n",
        },
        {
          "<leader>[",
          function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
          end,
          desc = "Swap Previous Parameter",
          mode = "n",
        },
      }
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub("@", ""):gsub("%..*", "")
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          result[#result + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end,
            desc = desc,
            mode = { "n", "x", "o" },
            silent = true,
          }
        end
      end
      return result
    end,
  },
}
