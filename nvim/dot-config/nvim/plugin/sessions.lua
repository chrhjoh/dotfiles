vim.pack.add { { src = "https://github.com/olimorris/persisted.nvim", version = "main" } }

function _G.should_save()
  local ignored_buftypes = { "snacks_dashboard", "gitcommit" }
  local root_markers = { ".git", "package.json", "Cargo.toml", "pyproject.toml" }

  local cwd = vim.fn.getcwd()

  if cwd ~= vim.fs.root(cwd, root_markers) then
    return false
  end

  local bufs = vim.fn.getbufinfo { buflisted = 1 }
  bufs = vim.tbl_filter(function(buf)
    return not vim.tbl_contains(ignored_buftypes, vim.bo[buf.bufnr].buftype)
      and vim.api.nvim_buf_get_name(buf.bufnr) ~= ""
  end, bufs)

  if #bufs < 1 then
    return false
  end

  if not vim.g.persisting then
    return false
  end

  return true
end

Core.loader.load_later(function()
  require("persisted").setup {
    use_git_branch = true,
    autostart = true,
    autoload = false,
    should_save = should_save,
  }
  vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedSelectPre",
    callback = function(_)
      if vim.g.persisted_loaded_session then
        require("persisted").save { session = vim.g.persisted_loaded_session }
      end
      Snacks.bufdelete.all {}
    end,
  })
end)
