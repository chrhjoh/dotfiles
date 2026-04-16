vim.pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig", version = "master" },
  { src = "https://github.com/folke/lazydev.nvim", version = "main" },
}
Config.load.load_on_ft("lua", function()
  require("lazydev").setup {
    library = {
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  }
end)

Config.load.load_eager_if_arg(function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", {}),
    callback = function(args)
      local act = vim.lsp.buf
      local mapping = function(key, action, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, key, action, { buffer = args.buf, desc = "LSP: " .. desc })
      end
      mapping("<leader>k", act.signature_help, "Signature Documentation")
      mapping("K", act.hover, "Hover Documentation")
      mapping("gD", act.declaration, "Goto Declaration")
      mapping("<leader>cr", act.rename, "Code Rename")
      mapping("<leader>ca", act.code_action, "Code Action")
    end,
  })

  vim.lsp.config("*", { root_markers = { ".git", ".envrc" } })

  vim.lsp.enable {
    "lua_ls",
    "rust_analyzer",
    "basedpyright",
    "texlab",
    "tinymist",
  }
end)
