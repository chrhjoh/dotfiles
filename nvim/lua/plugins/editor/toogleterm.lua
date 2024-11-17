return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = true,
  cmd = "ToggleTerm",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.25
        else
          return 60
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = false,
      direction = "float",
      close_on_exit = false,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
        width = 200,
        height = 50,
      },
    })
  end,
  keys = {
    [[<c-\>]],
    { "<leader>tl", ":ToggleTermSendCurrentLine<CR>",       desc = "Send current line to terminal",            mode = "n" },
    { "<leader>tv", ":ToggleTermSendVisualLines<CR>",       desc = "Send selected lines to terminal",          mode = "v" },
    { "<leader>tV", ":ToggleTermSendVisualSelection<CR>",   desc = "Send selection to terminal",               mode = "v" },
    { "<leader>t|", ":ToggleTerm direction=vertical<CR>",   desc = "Open vertical terminal" },
    { "<leader>t-", ":ToggleTerm direction=horizontal<CR>", desc = "Open horizontal terminal" },
    { "<leader>tf", ":ToggleTerm direction=float<CR>",      desc = "Open float terminal" },
    { "<leader>tt", ":ToggleTerm<CR>",                      desc = "Toggle Current Terminal (or open default)" },
  },
}
