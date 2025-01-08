local git_mapper = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Git" }
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  keys = function()
    return git_mapper {
      -- Navigation
      {
        "]h",
        function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            require("gitsigns").nav_hunk("next")
          end)
          return "<Ignore>"
        end,
        expr = true,
        desc = "Jump to next hunk",
        mode = { "n", "v" },
      },

      {
        "[h",
        function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            require("gitsigns").nav_hunk("prev")
          end)
          return "<Ignore>"
        end,
        expr = true,
        desc = "Jump to previous hunk",
        mode = { "n", "v" },
      },

      -- Actions
      -- visual mode
      {
        "<leader>gs",
        function()
          require("gitsigns").stage_hunk { vim.fn.line("."), vim.fn.line("v") }
        end,
        desc = "Stage hunk",
        mode = "v",
      },

      {
        "<leader>gr",
        function()
          require("gitsigns").reset_hunk { vim.fn.line("."), vim.fn.line("v") }
        end,
        desc = "Reset hunk",
        mode = "v",
      },

      -- normal mode
      {
        "<leader>gh",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "stage hunk",
      },

      {
        "<leader>gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "reset hunk",
      },

      {
        "<leader>gS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "stage buffer",
      },

      {
        "<leader>gu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        desc = "Undo stage hunk",
      },

      {
        "<leader>gR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "reset buffer",
      },

      {
        "<leader>gp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview hunk",
      },

      {
        "<leader>gd",
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        desc = "diff inline",
      },

      {
        "<leader>gD",
        function()
          require("gitsigns").diffthis("~")
        end,
        desc = "diff against last commit",
      },

      -- Text object
      { "gih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select git hunk", mode = { "o", "x" } },
    }
  end,
}
