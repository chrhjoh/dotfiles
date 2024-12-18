local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- See `:help K` for why this keymap
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
  vim.keymap.set('i', '<C-?>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature', noremap = true })
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  vim.keymap.set(
    'n',
    'gd',
    '<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto Definition' }
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'References', nowait = true }
  )
  vim.keymap.set(
    'n',
    'gI',
    '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto Implementation' }
  )
  vim.keymap.set(
    'n',
    'gy',
    '<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto T[y]pe Definition' }
  )
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = {
      severity = { min = vim.diagnostic.severity.INFO },
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

return {
  'williamboman/mason-lspconfig.nvim',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      dependencies = {
        { 'gonstoll/wezterm-types', lazy = true },
      },
      opts = {
        library = {
          { path = 'wezterm-types', mods = { 'wezterm' } },
          { path = 'snacks.nvim', words = { 'Snacks' } },
        },
      },
    },
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
  },
  config = function()
    require('mason-lspconfig').setup {
      automatic_installation = true,
    }
    local lspconfig = require('lspconfig')
    lspconfig.julials.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }

    lspconfig.basedpyright.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = 'standard',
            diagnosticSeverityOverrides = {
              reportMissingParameterType = 'warning',
              reportMissingTypeArgument = 'warning',
              reportUnnecessaryComparison = 'warning',
              reportUnnecessaryContains = 'warning',
              reportUnnecessaryIsInstance = 'warning',
            },
          },
        },
      },
      filetypes = { 'python', 'snakemake' },
    }
    lspconfig.jsonls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          format = { enable = false },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = {},
        },
      },
    }
    lspconfig.texlab.setup {}
    lspconfig.tinymist.setup {}
    lspconfig.nil_ls.setup {}
    lspconfig.ltex.setup = {
      autostart = false, -- LTeX is too heavy for regular use.
    }
  end,
}
