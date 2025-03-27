return {
  {
    "williamboman/mason.nvim",
    build = ":MasonInstall basedpyright rust-analyzer json-lsp lua-language-server markdown-oxide texlab ruff stylua snakefmt isort debugpy",
    event = { "VeryLazy" },
    opts = {},
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  },
  { --BUG: Currently lazydev does nothing??
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "gonstoll/wezterm-types" },
    opts = {
      debug = true,
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- "${3rd}/busted/library",
      },
    },
  },
}
