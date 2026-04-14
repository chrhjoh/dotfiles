--TODO: setup sidekick and copilot when the github copilot is back
vim.pack.add {
  { src = "https://github.com/folke/sidekick.nvim", version = "main" },
  { src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
  { src = "https://github.com/copilotlsp-nvim/copilot-lsp", version = "main" },
}

Config.load.load_later(function()
  vim.g.sidekick_nes = false
  require("copilot").setup {
    suggestion = {
      enabled = false,
      auto_trigger = true,
      keymap = {
        accept = "<M-y>",
        accept_word = "<M-Y>",
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
