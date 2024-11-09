-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
    -- NOTE: Yes, you can install new plugins here!
    "mfussenegger/nvim-dap",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",

        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "python",
                "codelldb",
            },
        })

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set("n", "<leader>dr", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        local python_configs = dap.configurations.python or {}
        dap.configurations.python = python_configs
        table.insert(python_configs, {
            type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Python: Launch file from current working directory",
            cwd = vim.fn.getcwd(),
            program = "${file}", -- This configuration will launch the current file if used.
        })
        table.insert(python_configs, {
            type = "python",
            request = "launch",
            name = "Python: Launch file with arguments",
            program = "${file}",
            args = function()
                local args_string = vim.fn.input("Arguments: ")
                return vim.split(args_string, " +")
            end,
        })
        table.insert(python_configs, {
            type = "python",
            request = "attach",
            name = "Python: Attach remote",
            connect = function()
                local host = vim.fn.input("Host [127.0.0.1]: ")
                host = host ~= "" and host or "127.0.0.1"
                local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
                return { host = host, port = port }
            end,
        })
    end,
    keys = {
        -- Basic debugging keymaps, feel free to change to your liking!
        { "<leader>dc", ":DapContinue<CR>", desc = "[D]ebug: Start/[C]ontinue" },
        { "<leader>di", ":DapStepInto<CR>", desc = "[D]ebug: Step [I]nto" },
        { "<leader>dn", ":DapStepOver<CR>", desc = "[D]ebug: Step Over/[N]ext" },
        { "<leader>do", ":DapStepOut<CR>", desc = "[D]ebug: Step [O]ut" },
        { "<leader>db", ":DapToggleBreakpoint<CR>", desc = "[D]ebug: Toggle [B]reakpoint" },
        { "<leader>dt", ":DapTerminate<CR>", desc = "[D]ebug: [T]erminate" },
    },
}
