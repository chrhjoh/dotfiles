return {
  lazy = true,
  event = "BufReadPost *.csv",
  'hat0uma/csvview.nvim',
  config = function()
    require('csvview').setup()
  end,
  keys = { "<leader>uC", "<CMD>CsvViewToggle<cr>", desc = "Toggle CSV" }
}
