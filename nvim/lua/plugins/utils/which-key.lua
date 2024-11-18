return {
    "folke/which-key.nvim",
    opts = {
        preset = "modern",
        icons = {
            separator = "→",
        },
        spec = {
            {
                mode = { "n", "v" },
                { "<leader>C",      group = "Copilot" },
                { "<leader>b",      group = "Buffers" },
                { "<leader>c",      group = "Code" },
                { "<leader>d",      group = "Debug" },
                { "<leader>f",      group = "Files" },
                { "<leader>g",      group = "Git" },
                { "<leader>gh",     group = "Git [H]unk" },
                { "<leader>o",      group = "Obsidian" },
                { "<leader>r",      group = "Refactor" },
                { "<leader>s",      group = "Search" },
                { "<leader>t",      group = "Terminal" },
                { "<leader>u",      group = "Toggle" },
                { "<leader>w",      group = "Window" },
                { "<leader>x",      group = "Diagnostics/quickfiX" },
                { "<leader>y",      group = "Yank" },
                { "<localleader>o", group = "Oil" },
                { "<localleader>l", group = "Latex" },
                { "<localleader>t", group = "Typst" },
                { "<localleader>m", group = "Markdown" },


                { "]",              group = "prev" },
                { "[",              group = "next" },
                { "g",              group = "goto" },
                { "gs",             group = "surround" },
                { "z",              group = "fold" },

            },
        }

    },
}
