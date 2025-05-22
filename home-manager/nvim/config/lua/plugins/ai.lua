return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-y>",
          accept_word = "<M-Y>",
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      mappings = {
        reset = {
          insert = "<C-c>",
          normal = "<C-c>",
        },
      },
    },
  },
}
