local session_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Session" }
return {
  "olimorris/persisted.nvim",
  event = "VeryLazy",
  opts = {
    use_git_branch = true,
    autostart = true,
    autoload = false,
    should_save = function()
      if vim.bo.filetype == "snacks_dashboard" then
        return false
      end

      local buffers = vim.api.nvim_list_bufs()
      if #buffers < 1 then
        return false
      end
      return true
    end,
  },
  keys = function()
    return session_map {
      { "<leader>ql", "<CMD>SessionLoad<CR>", desc = "Restore For Current Directory" },
      { "<leader>qS", "<CMD>SessionSelect<CR>", desc = "Select" },
      { "<leader>qs", "<CMD>SessionSave<CR>", desc = "Save" },
      { "<leader>qL", "<CMD>SessionLoadLast<CR>", desc = "Restore Last" },
      { "<leader>qd", "<CMD>SessionDelete<CR>", desc = "Delete Current" },
    }
  end,
}
