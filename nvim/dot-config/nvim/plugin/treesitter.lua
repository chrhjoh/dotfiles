vim.pack.add {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
}

Config.load.load_eager_if_arg(function()
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
