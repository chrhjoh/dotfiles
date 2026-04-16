vim.pack.add {
  { src = "https://github.com/folke/sidekick.nvim", version = "main" },
  { src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
}

Config.load.load_later(function()
  require("copilot").setup {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<M-y>",
        accept_word = "<S-Tab>",
        toggle_auto_trigger = "<M-Y>",
      },
    },
  }
  require("sidekick").setup {
    cli = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
    },
  }
end)
