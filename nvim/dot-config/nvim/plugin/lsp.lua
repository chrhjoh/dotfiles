vim.pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig", version = "master" },
  { src = "https://github.com/folke/lazydev.nvim", version = "main" },
}
Core.loader.load_on_ft("lua", function()
  require("lazydev").setup {
    library = {
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  }
end)

Core.loader.load_eager_if_arg(function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      local act = vim.lsp.buf
      local keymap = function(key, action, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, key, action, { buffer = args.buf, desc = "LSP: " .. desc })
      end

      keymap("<leader>k", function()
        act.signature_help { border = "bold" }
      end, "Signature Documentation")
      keymap("K", function()
        act.hover { border = "bold" }
      end, "Hover Documentation")
      keymap("gD", act.declaration, "Goto Declaration")
      keymap("<leader>cr", act.rename, "Code Rename")
      keymap("<leader>ca", act.code_action, "Code Action")

      if not client then
        return
      end

      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end
    end,
  })

  vim.lsp.config("*", { root_markers = { ".git", ".envrc" } })

  vim.lsp.enable {
    "lua_ls",
    "rust_analyzer",
    "pyrefly",
    "ruff",
    "texlab",
    "tinymist",
  }
end)
