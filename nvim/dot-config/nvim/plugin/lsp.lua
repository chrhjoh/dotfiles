vim.pack.add { { src = "https://github.com/neovim/nvim-lspconfig", version = "master" } }

local setup = function()
  vim.lsp.config("*", { root_markers = { ".git", ".envrc" } })

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
      mapping("<leader>ca", act.rename, "Code Action")
      mapping("<C-?>", act.signature_help, "Signature Documentation", "i")
    end,
  })

  vim.lsp.enable {
    "lua_ls",
    "rust_analyzer",
    "basedpyright",
    "texlab",
    "tinymist",
  }
end

Config.load.load_eager_if_arg(setup)
