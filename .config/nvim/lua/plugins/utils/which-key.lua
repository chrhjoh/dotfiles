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
                { "<leader>C",  group = "[C]opilot" },
                { "<leader>b",  group = "[B]uffers" },
                { "<leader>c",  group = "[C]ode" },
                { "<leader>d",  group = "[D]ebug" },
                { "<leader>f",  group = "[F]iles" },
                { "<leader>g",  group = "[G]it" },
                { "<leader>gh", group = "[G]it [H]unk" },
                { "<leader>l",  group = "[L]atex" },
                { "<leader>o",  group = "[O]bsidian" },
                { "<leader>r",  group = "[R]ename" },
                { "<leader>s",  group = "[S]earch" },
                { "<leader>t",  group = "[T]erminal" },
                { "<leader>u",  group = "Toggle" },
                { "<leader>w",  group = "[W]indow" },
                { "<leader>x",  group = "Diagnostics/quickfi[X]" },
                { "[",          group = "prev" },
                { "]",          group = "next" },
                { "g",          group = "goto" },
                { "gs",         group = "surround" },
                { "z",          group = "fold" },
            },
        }

    },
}
