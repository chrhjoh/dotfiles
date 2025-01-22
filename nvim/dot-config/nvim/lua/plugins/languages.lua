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
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    build = function()
      require("typst-preview").update()
    end,
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
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    --stylua: ignore
    keys = function()
      markview_mapper {
        { "<localleader>mt", "<cmd>Markview toggle<cr>",        desc = "Toggle" },
        { "<localleader>ms", "<cmd>Markview splitToggle<cr>",   desc = "Split Toggle" },
        { "<localleader>mh", "<cmd>Markview hybridToggle<cr>",  desc = "hybrid Toggle" },
        { "<localleader>mo", "<cmd>Markopen<cr>",               desc = "hybrid Toggle" },
      }
    end,
  },
  {
    "hat0uma/csvview.nvim",
    event = "BufReadPost *.csv",
    config = function()
      require("csvview").setup()
    end,
  },
}
