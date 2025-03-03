---@class ToolModule
M = {}

---@type FormatterToolConfig[]
M.formatters = {
  { name = "isort", filetypes = { "python" } },
  { name = "ruff_format", filetypes = { "python" }, mason_alias = "ruff" },
  { name = "snakefmt", filetypes = { "snakemake" } },
  { name = "stylua", filetypes = { "lua" } },
  { name = "typstfmt", filetypes = { "typst" } },
}

---@type DebuggerToolConfig[]
M.debuggers = {
  {
    name = "debugpy",
    filetypes = { "python" },
    opts = {
      adapter = {
        type = "executable",
        command = vim.fn.exepath("debugpy-adapter"),
      },
      configurations = {
        {
          type = "python",
          request = "launch",
          name = "Python: Current Working Directory",
          cwd = vim.fn.getcwd(),
          program = "${file}",
          pythonPath = Utils.lang.get_python_path(),
        },
      },
    },
  },
  {
    name = "codelldb",
    ensure_install = false,
    filetypes = { "rust" },
    opts = {
      adapter = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      },
      configurations = {
        {
          name = "LLDB: Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            vim.fn.input {
              prompt = "Path to executable: ",
              default = vim.fn.getcwd() .. "/",
              completion = "file",
            }
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          console = "integratedTerminal",
        },
      },
    },
  },
}

---@type LspToolConfig[]
M.lsps = {
  {
    name = "basedpyright",
    filetypes = { "python", "snakemake" },
    opts = {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
          },
        },
      },
    },
  },
  { name = "jsonls", mason_alias = "json-lsp" },
  { name = "julials", mason_alias = "julia-lsp" },
  { name = "rust_analyzer", mason_alias = "rust-analyzer" },
  {
    name = "lua_ls",
    mason_alias = "lua-language-server",
    opts = {
      settings = {
        Lua = {
          format = { enable = false },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          diagnostics = {},
        },
      },
    },
  },
  { name = "texlab", ensure_install = false },
  { name = "ltex", opts = { autostart = false }, mason_alias = "ltex-ls", ensure_install = false },
  { name = "tinymist", ensure_install = false },
  {
    name = "markdown_oxide",
    mason_alias = "markdown-oxide",
    opts = {},
    on_attach_callback = function(client, bufnr)
      client.server_capabilities.renameProvider = false
      client.server_capabilities.workspace.fileOperations = {
        willRename = false,
        didRename = false,
        willCreate = false,
        didCreate = false,
        willDelete = false,
        didDelete = false,
      }
    end,
  },
}

return M
