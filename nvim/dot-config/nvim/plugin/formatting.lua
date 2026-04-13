vim.pack.add { { src = "https://github.com/stevearc/conform.nvim", version = "master" } }

local setup = function()
  require("conform").setup {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      snakemake = { "snakefmt" },
      typst = { "typstfmt" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { async = false, lsp_fallback = true }
    end,
  }
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

Config.load.load_on_event(setup, { "BufNewFile", "BufReadPost", "BufWritePre" })
