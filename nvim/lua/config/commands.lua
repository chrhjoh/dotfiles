vim.api.nvim_create_user_command("Configurations", function()
  local CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
  vim.api.nvim_set_current_dir(CONFIG_HOME)
end, {})
