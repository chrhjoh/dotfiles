vim.pack.add { { src = "https://github.com/olimorris/persisted.nvim", version = "main" } }

Config.load.load_later(function()
  require("persisted").setup {
    use_git_branch = true,
    autostart = true,
    autoload = false,
    ignored_dirs = { { "~", exact = true } },
    should_save = function()
      if vim.bo.filetype == "snacks_dashboard" then
        return false
      elseif #vim.api.nvim_list_bufs() < 1 then
        return false
      end
      return true
    end,
  }
end)
