local nmap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Code Companion" }
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
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanionChat", "CodeCompanion" },
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
          -- Add keymaps for chat such as
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = function()
      return nmap {
        { "<leader>Aq", "<cmd>CodeCompanion<cr>", desc = "Quick Chat" },
        { "<leader>Aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions" },
        { "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat Window" },
        { "<leader>Ae", "<cmd>CodeCompanion /explain <cr>", desc = "Explain Code", mode = { "n", "v" } },
        { "<leader>Af", "<cmd>CodeCompanion /fix <cr>", desc = "Fix Code", mode = { "n", "v" } },
      }
    end,
  },
}
