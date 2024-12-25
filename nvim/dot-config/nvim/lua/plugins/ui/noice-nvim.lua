return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'stevearc/dressing.nvim',
      opts = {},
    },
  },
  opts = {
    cmdline = {
      view = 'cmdline',
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      progress = { enabled = false },
    },
    messages = { view_search = false },
    routes = {
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
          },
        },
        view = 'mini',
      },
    },
    presets = {
      bottom_search = true,
      long_message_to_split = true,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>n",  "",                                                                            desc = "+noice" },
    { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
    { "<leader>nt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" }, },
    { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" }, },
  },
  config = function(_, opts)
    require('noice').setup(opts)
  end,
}
