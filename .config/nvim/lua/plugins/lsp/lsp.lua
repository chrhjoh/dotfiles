local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- See `:help K` for why this keymap
  nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
  vim.keymap.set("i", "<C-?>", vim.lsp.buf.signature_help, { desc = "LSP: Signature", noremap = true })
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>cD", require("telescope.builtin").lsp_type_definitions, "[C]ode Type [D]efinition")
  nmap("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[C]ode Document [S]ymbols")
  nmap("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[Code] Workspace [S]ymbols")

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = {
      severity = { min = vim.diagnostic.severity.INFO },
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

return {
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-lspconfig").setup({
      automatic_installation = true,
    })
    local lspconfig = require("lspconfig")
    lspconfig.julials.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            diagnosticSeverityOverrides = {
              reportInvalidTypeArguments = "warning",
              reportArgumentType = "information",
              reportGeneralTypeIssues = "information",
              reportReturnType = "information",
              reportIncompatibleMethodOverride = "information",
              reportIncompatibleVariableOverride = "warning",
              reportPossiblyUnboundVariable = "warning",
            },
            typeCheckingMode = "basic",
          },
        },
      },
      filetypes = { "python", "snakemake" },
    })
    lspconfig.bashls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lspconfig.marksman.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            }
          },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
    })
    lspconfig.texlab.setup({
    })
  end,
}
