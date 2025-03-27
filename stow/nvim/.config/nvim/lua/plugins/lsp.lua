return {
  {
    "williamboman/mason.nvim",
    build = {
      ":MasonUpdate",
      function(plugin)
        Utils.tools.install_ensured()
      end,
    },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "folke/lazydev.nvim" },
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
