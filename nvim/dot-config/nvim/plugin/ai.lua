vim.pack.add {
  { src = "https://github.com/folke/sidekick.nvim", version = "main" },
  { src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
}

Config.loader.load_later(function()
  vim.g.copilot_enabled = false
  require("copilot").setup {
    filetypes = {
      tex = false,
    },
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<M-y>",
        accept_word = "<S-Tab>",
        toggle_auto_trigger = "<M-Y>",
      },
    },
  }
  require("copilot.command").disable()
  vim.g.sidekick_nes_enabled = false
  require("sidekick").setup {
    cli = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
    },
  }
end)
