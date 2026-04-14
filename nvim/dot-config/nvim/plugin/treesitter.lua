vim.pack.add {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
}
--TODO: defer update part to to a build step
Config.load.load_eager_if_arg(function()
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
  local ts = require("nvim-treesitter")
  ts.update()
  local installed = ts.get_installed()
  local to_install = vim.tbl_filter(function(parser)
    return not vim.list_contains(installed, parser)
  end, ensure_installed)
  ts.install(to_install):wait(300000)

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
end)
