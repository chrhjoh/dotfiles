local lsp_map = Utils.keymap.get_mapper { mode = "n", desc_prefix = "LSP" }
return {
  {
    "williamboman/mason.nvim",
    build = {
      ":MasonUpdate",
      function(plugin)
        Utils.tools.install_ensured()
      end,
    },
    opts = {},
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "folke/lazydev.nvim" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
    config = function()
      local on_attach = function(client, bufnr)
        lsp_map { "<leader>k", vim.lsp.buf.signature_help, desc = "Signature Documentation", buffer = bufnr }
        lsp_map { "K", vim.lsp.buf.hover, desc = "Hover Documentation", buffer = bufnr }
        lsp_map { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", buffer = bufnr }
        lsp_map { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", buffer = bufnr }
        lsp_map { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", buffer = bufnr }
        lsp_map { "<C-?>", vim.lsp.buf.signature_help, desc = "LSP: Signature", buffer = bufnr, mode = "i" }

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          signs = {
            severity = { min = vim.diagnostic.severity.INFO },
          },
          virtual_text = {
            severity = { min = vim.diagnostic.severity.WARN },
          },
        })
      end
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )
      ---@param server LspToolConfig
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = on_attach,
        }, server.opts or {})
        require("lspconfig")[server.name].setup(server_opts)
      end
      local servers = require("config.tools").lsps
      for _, server in ipairs(servers) do
        setup(server)
      end
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "gonstoll/wezterm-types" },
    opts = {
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- "${3rd}/busted/library",
      },
    },
  },
}
