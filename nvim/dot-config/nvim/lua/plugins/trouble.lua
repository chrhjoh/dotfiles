local trouble_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Trouble" }
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  keys = function()
    return trouble_map {
      { "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>lD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cy", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      {
        "<leader>cY",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)",
      },
      { "<leader>lL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>lQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List " },
      {
        "<leader>lt",
        function()
          require("trouble").toggle { mode = "todo" }
        end,
        desc = "Todo",
      },
      {
        "<leader>lT",
        function()
          require("trouble").toggle { mode = "todo", filter = { { tag = { "TODO", "FIX", "FIXME" } } } }
        end,
        desc = "Todo/Fix/Fixme",
      },
    }
  end,
}
