return {
  "stevearc/aerial.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = function()
    -- HACK: fix lua's weird choice for `Package` for control
    -- structures like if/else/for/etc.

    local opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      layout = {
        resize_to_content = false,
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
      -- stylua: ignore
      guides = {
        mid_item   = "├╴",
        last_item  = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
    }
    return opts
  end,
  keys = {
    { "<leader>cA", "<cmd>AerialToggle<cr>", desc = "Code Aerial (Symbols)" },
  },
}
