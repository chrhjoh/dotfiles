return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
  root_markers = { "stylua.toml" },
  settings = {
    Lua = {
      format = { enable = false },
      workspace = {
        checkThirdParty = true,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
    },
  },
}
