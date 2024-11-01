return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        {
            "rcarriga/nvim-notify",
            config = function()
                require('notify').setup({
                    render = "wrapped-compact"
                })
            end
        },
    },
    config = function()
        require("noice").setup({
            routes = {
                {
                    filter = {
                        event = "lsp",
                        kind = "progress",
                    },
                    opts = { skip = true },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            views = {
                cmdline_popup = {
                    border = {
                        style = "single",
                        padding = { 0, 0 },
                    },
                    filter_options = {},
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    border = {
                        style = "none",
                        padding = { 0, 0 },
                    },
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
            },
        })
    end,
    keys = {
        { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
        { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
        { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
        { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
        { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
        { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
        { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,              expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
}
