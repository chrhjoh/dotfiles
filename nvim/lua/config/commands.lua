vim.api.nvim_create_user_command("Configurations", function()
  local CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
  vim.api.nvim_set_current_dir(CONFIG_HOME)
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
