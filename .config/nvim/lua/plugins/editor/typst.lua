return { {
  'kaarmu/typst.vim',
  ft = 'typst',
  init = function()
    vim.g.typst_conceal = 2
  end
}, {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  version = '*',
  build = function() require 'typst-preview'.update() end,
  keys = {
    { "<localleader>td", ":TypstPreview document<CR>",          desc = "Typst Preview Document" },
    -- Start Typst preview in slide mode
    { "<localleader>ts", ":TypstPreview slide<CR>",             desc = "Typst Preview Slide" },
    -- Stop Typst preview
    { "<localleader>tp", ":TypstPreviewStop<CR>",               desc = "Typst Preview Stop" },
    -- Toggle follow cursor mode
    { "<localleader>tf", ":TypstPreviewFollowCursorToggle<CR>", desc = "Typst Preview Follow Cursor Toggle" },
    -- Synchronize cursor position
    { "<localleader>ty", ":TypstPreviewSyncCursor<CR>",         desc = "Typst Preview Sync Cursor" },
  }
} }
