local typst_mapper = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Typst" }
local markview_mapper = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Markview" }
return {
  {
    "lervag/vimtex",
    lazy = false, -- Reuired for inverse searching
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "skim"
      vim.g.tex_conceal = "abdmg"
    end,
  },
  {
    "kaarmu/typst.vim",
    ft = "typst",
    init = function()
      vim.g.typst_conceal = 2
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_syntax_conceal_disable = 1
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = { dependencies_bin = {
      ["tinymist"] = "tinymist",
      ["websocat"] = "websocat",
    } },
    --stylua: ignore
    keys = function()
      return typst_mapper {
        { "<localleader>td", ":TypstPreview document<CR>",          desc = "Preview Document" },
        { "<localleader>ts", ":TypstPreview slide<CR>",             desc = "Preview Slide" },
        { "<localleader>tp", ":TypstPreviewStop<CR>",               desc = "Preview Stop" },
        { "<localleader>tf", ":TypstPreviewFollowCursorToggle<CR>", desc = "Preview Follow Cursor Toggle" },
        { "<localleader>ty", ":TypstPreviewSyncCursor<CR>",         desc = "Preview Sync Cursor" },
      }
    end,
  },
  {
    "snakemake/snakemake",
    ft = "snakemake",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/misc/vim")
    end,
    init = function(plugin)
      require("lazy.core.loader").ftdetect(plugin.dir .. "/misc/vim")
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "codecompanion" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    opts = function()
      return {
        preview = {
          filetypes = { "markdown", "codecompanion" },
          ignore_buftypes = {},
          icon_provider = "mini",
        },
        markdown = {
          horizontal_rules = require("markview.presets").horizontal_rules.thick,
        },
      }
    end,
    config = function(_, opts)
      require("markview").setup(opts)
      require("markview.extras.checkboxes").setup()
    end,
    --stylua: ignore
    keys = function()
      return markview_mapper {
        { "<localleader>mo", "<cmd>Markview open<cr>", desc = "Open Web Link" },
        { "<localleader>mc", "<cmd>Checkbox interactive<cr>", desc = "Checkbox" },
      }
    end,
  },
}
