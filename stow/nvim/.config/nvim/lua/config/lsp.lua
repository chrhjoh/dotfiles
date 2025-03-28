local lsp_map = Utils.keymap.get_mapper { mode = "n", desc_prefix = "LSP" }

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    prefix = function(diagnostic)
      local icons = Utils.icons.diagnostics
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
      return ""
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Utils.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = Utils.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = Utils.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = Utils.icons.diagnostics.Info,
    },
    severity = { min = vim.diagnostic.severity.INFO },
  },
}
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DefaultLspAttach", {}),
  callback = function(args)
    lsp_map { "<leader>k", vim.lsp.buf.signature_help, desc = "Signature Documentation", buffer = args.buf }
    lsp_map { "K", vim.lsp.buf.hover, desc = "Hover Documentation", buffer = args.buf }
    lsp_map { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", buffer = args.buf }
    lsp_map { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", buffer = args.buf }
    lsp_map { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", buffer = args.buf }
    lsp_map { "<C-?>", vim.lsp.buf.signature_help, desc = "LSP: Signature", buffer = args.buf, mode = "i" }

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.name == "markdown-oxide" then
      client.server_capabilities.renameProvider = false
      client.server_capabilities.workspace.fileOperations = {
        willRename = false,
        didRename = false,
        willCreate = false,
        didCreate = false,
        willDelete = false,
        didDelete = false,
      }
    end
  end,
})

vim.lsp.config("*", { root_markers = { ".git" } })
vim.lsp.enable { "lua_ls", "rust-analyzer", "basedpyright", "json-lsp", "markdown-oxide", "texlab" }
