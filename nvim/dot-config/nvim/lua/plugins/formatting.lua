local conform_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Conform" }
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    dependencies = { "williamboman/mason.nvim" }, -- To setup mason on path
    opts = function()
      return {
        formatters_by_ft = require("utils.tools").by_filetype("formatters"),
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { async = false, lsp_fallback = true }
        end,
      }
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = function()
      return conform_map {
        {
          "<leader>cf",
          function()
            require("conform").format { async = false, lsp_fallback = true }
          end,
          mode = "n",
          desc = "Format Buffer",
        },
      }
    end,
  },
}
