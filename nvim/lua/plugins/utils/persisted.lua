return {
  "olimorris/persisted.nvim",
  lazy = false,
  config = function()
    require('persisted').setup({
      use_git_branch = true,
      autostart = false,
      autoload = true,
    })
  end,
  keys = {
    { "<leader>ql", "<CMD>SessionLoad<CR>",     desc = "Restore Session for current directory" },
    { "<leader>qS", "<CMD>SessionSelect<CR>",   desc = "Select Session" },
    { "<leader>qs", "<CMD>SessionSave<CR>",     desc = "Save Session" },
    { "<leader>qL", "<CMD>SessionLoadLast<CR>", desc = "Restore Last Session" },
    { "<leader>qd", "<CMD>SessionDelete<CR>",   desc = "Delete Current Session" },
  }

}
