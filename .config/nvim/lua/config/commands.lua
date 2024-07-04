local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

vim.api.nvim_create_user_command("Configurations", function()
  local CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
  vim.api.nvim_set_current_dir(CONFIG_HOME)
end, {})

vim.api.nvim_create_user_command("ToggleGitConfigurations", function()
  -- Set these to make vim fugitive and gitsigns work with bare dotfile directory
  if not vim.env.GIT_DIR then
    vim.env.GIT_DIR = vim.env.DOTBARE_DIR
    vim.env.GIT_WORK_TREE = vim.env.DOTBARE_TREE
    print("Set Git to track Dotfiles")
  else
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
    print("Removed Git Dotfile tracking")
  end
end, {})

vim.api.nvim_create_user_command("ToggleFormat", function(args)
  if args.bang then
    -- ToggleFormat! will disable formatting just for this buffer
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      print("Disabled auto-format-on-save for buffer")
    else
      print("Enabled auto-format-on-save for buffer")
    end
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      print("Disabled auto-format-on-save")
    else
      print("Enabled auto-format-on-save")
    end
  end
end, {
  desc = "Toggle auto-format-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  if not vim.diagnostic.is_enabled({ bufnr = 0 }) then
    vim.diagnostic.enable(true, { bufnr = 0 })
    print("Enabled diagnostics")
  else
    vim.diagnostic.enable(false, { bufnr = 0 })
    print("Disabled diagnostics")
  end
end, {
  desc = "Toggle Diagnostics",
})

vim.api.nvim_create_user_command("BdeleteHigher", function()
  vim.cmd('execute (bufnr("%") + 1) .. "," .. bufnr("$") .. "bd"')
end, {})

vim.api.nvim_create_user_command("BdeleteLower", function()
  local curbuf = vim.fn.bufnr("%")
  if curbuf > 1 then
    -- Build the range string for buffers less than the current one
    local range = "1," .. (curbuf - 1)
    -- Execute the buffer delete command on the specified range
    vim.cmd(range .. "bd")
  end
end, {})
