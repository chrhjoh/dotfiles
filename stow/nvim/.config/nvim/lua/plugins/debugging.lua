local debug_mapper = Utils.keymap.get_lazy_list_mapper { desc_prefix = "Debug", mode = "n" }
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local debugpy = {
  adapter = {
    type = "executable",
    command = vim.fn.exepath("debugpy-adapter"),
  },
  configurations = {
    {
      type = "python",
      request = "launch",
      name = "Python: Current Working Directory",
      cwd = vim.fn.getcwd(),
      program = "${file}",
      pythonPath = Utils.lang.get_python_path(),
    },
  },
}

local codelldb = {
  adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.exepath("codelldb"),
      args = { "--port", "${port}" },
    },
  },
  configurations = {
    {
      name = "LLDB: Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        vim.fn.input {
          prompt = "Path to executable: ",
          default = vim.fn.getcwd() .. "/",
          completion = "file",
        }
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      console = "integratedTerminal",
    },
  },
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      dap.adapters["python"] = debugpy.adapter
      dap.configurations["python"] = debugpy.configurations
      dap.adapters["rust"] = codelldb.adapter
      dap.configurations["rust"] = codelldb.configurations
      -- Make Dap points more visible
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = " ", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
      )
    end,
    --stylua: ignore
    keys = function()
      return debug_mapper {
        {  "<leader>dB",  function()    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))  end, desc = "Breakpoint Condition",} ,
        {  "<leader>db",  function()    require("dap").toggle_breakpoint()  end,                                    desc = "Toggle Breakpoint",} ,
        {  "<leader>dc",  function()    require("dap").continue()  end,                                             desc = "Run/Continue",} ,
        {  "<leader>da",  function()    require("dap").continue { before = get_args }  end,                         desc = "Run with Args",} ,
        {  "<leader>dC",  function()    require("dap").run_to_cursor()  end,                                        desc = "Run to Cursor",} ,
        {  "<leader>dg",  function()    require("dap").goto_()  end,                                                desc = "Go to Line (No Execute)",} ,
        {  "<leader>di",  function()    require("dap").step_into()  end,                                            desc = "Step Into",} ,
        {  "<leader>dj",  function()    require("dap").down()  end,                                                 desc = "Down",} ,
        {  "<leader>dk",  function()    require("dap").up()  end,                                                   desc = "Up",} ,
        {  "<leader>dl",  function()    require("dap").run_last()  end,                                             desc = "Run Last",} ,
        {  "<leader>dO",  function()    require("dap").step_out()  end,                                             desc = "Step Out",} ,
        {  "<leader>do",  function()    require("dap").step_over()  end,                                            desc = "Step Over",} ,
        {  "<leader>dP",  function()    require("dap").pause()  end,                                                desc = "Pause",} ,
        {  "<leader>dr",  function()    require("dap").repl.toggle()  end,                                          desc = "Toggle REPL",} ,
        {  "<leader>ds",  function()    require("dap").session()  end,                                              desc = "Session",} ,
        {  "<leader>dt",  function()    require("dap").terminate()  end,                                            desc = "Terminate",} ,
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
    --stylua: ignore
    keys = function()
      return debug_mapper {
        {  "<leader>du",  function()    require("dapui").toggle {}  end,  desc = "Dap UI",  expr = true,} ,
        {  "<leader>de",  function()    require("dapui").eval()  end,     desc = "Eval",    mode = { "n", "v" },} ,
      }
    end,
  },
  { "theHamsta/nvim-dap-virtual-text", opts = {}, lazy = true },
}
