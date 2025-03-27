---@class ToolModule
M = {}

---@type FormatterToolConfig[]
M.formatters = {
  isort = { filetypes = { "python" } },
  ruff_format = { filetypes = { "python" }, mason_alias = "ruff" },
  snakefmt = { filetypes = { "snakemake" } },
  stylua = { filetypes = { "lua" } },
  typstfmt = { filetypes = { "typst" } },
}

---@type DebuggerToolConfig[]
M.debuggers = {
  debugpy = {
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
  codelldb = {
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
  basedpyright = {
    filetypes = { "python", "snakemake" },
    opts = {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            autoImportCompletions = false,
          },
        },
      },
    },
  },
  jsonls = { mason_alias = "json-lsp" },
  julials = { mason_alias = "julia-lsp" },
  rust_analyzer = { mason_alias = "rust-analyzer" },
  lua_ls = {
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
  texlab = { ensure_install = false },
  ltex = { opts = { autostart = false }, mason_alias = "ltex-ls", ensure_install = false },
  tinymist = { ensure_install = false },
  markdown_oxide = {
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
