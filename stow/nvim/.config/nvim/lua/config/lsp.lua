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
local wrap_on_attach = function(server)
  return function(client, bufnr)
    lsp_map { "<leader>k", vim.lsp.buf.signature_help, desc = "Signature Documentation", buffer = bufnr }
    lsp_map { "K", vim.lsp.buf.hover, desc = "Hover Documentation", buffer = bufnr }
    lsp_map { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", buffer = bufnr }
    lsp_map { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", buffer = bufnr }
    lsp_map { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", buffer = bufnr }
    lsp_map { "<C-?>", vim.lsp.buf.signature_help, desc = "LSP: Signature", buffer = bufnr, mode = "i" }
    if server and server.on_attach_callback then
      server.on_attach_callback(client, bufnr)
    end
  end
end
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)
local function setup(name, config)
  local opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
    on_attach = wrap_on_attach(config),
  }, config.opts or {})
  require("lspconfig")[name].setup(opts)
end
local servers = require("config.tools").lsps
for name, config in pairs(servers) do
  setup(name, config)
end
