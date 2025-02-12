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
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
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
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)
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
      ---@param server LspToolConfig
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = wrap_on_attach(server),
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
