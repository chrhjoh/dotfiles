vim.pack.add {
  { src = "https://github.com/folke/sidekick.nvim", version = "main" },
  { src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
}

Config.load.load_later(function()
  require("copilot").setup {
    suggestion = {
      auto_trigger = false,
      keymap = {
        accept = "<M-y>",
        accept_word = "<S-Tab>",
        toggle_auto_trigger = "<M-Y>",
      },
    },
  }
  vim.g.sidekick_nes = false
  require("sidekick").setup {
    cli = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
    },
  }
end)
