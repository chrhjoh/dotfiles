return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  ---@class wk.Opts
  opts = {
    preset = "helix",
    icons = {
      separator = "→",
      rules = {
        { pattern = "put", icon = "󰅇 ", color = "yellow" },
        { pattern = "yank", icon = "󰅇 ", color = "yellow" },
        { pattern = "lists", icon = " ", color = "green" },
        { pattern = "lua", icon = "󰢱 ", color = "blue" },
      },
    },
    spec = {
      {
        mode = { "n", "v" },
        {
          "<leader>b",
          group = "buffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>c", group = "code" },
        { "<leader>l", group = "lists" },
        { "<leader>f", group = "files" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "searches" },
        { "<leader>t", group = "terminals" },
        { "<leader>u", group = "toggles" },
        { "<leader>w", group = "windows", proxy = "<c-w>" },
        { "<leader>y", group = "yank" },
        { "<leader>d", desc = "debug" },
        { "<leader>q", desc = "sessions" },
        { "<leader>n", desc = "+noice" },

        { "<localleader>l", group = "latex" },
        { "<localleader>t", group = "typst" },
        { "<localleader>m", group = "markdown" },

        { "]", group = "prev" },
        { "[", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },
}
