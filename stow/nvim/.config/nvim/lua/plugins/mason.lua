return {
  {
    "williamboman/mason.nvim",
    build = ":MasonInstall basedpyright rust-analyzer json-lsp lua-language-server markdown-oxide texlab ruff stylua snakefmt isort debugpy",
    event = { "VeryLazy" },
    opts = {},
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  },
}
