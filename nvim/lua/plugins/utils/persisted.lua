return {
  "olimorris/persisted.nvim",
  lazy = false,
  config = function()
    require('persisted').setup({
      use_git_branch = true,
      autostart = true,
      autoload = false,
      should_save = function()
        if vim.bo.filetype == "snacks_dashboard" then return false end

        local buffers = vim.api.nvim_list_bufs()
        if #buffers < 1 then return false end
        return true
      end
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
