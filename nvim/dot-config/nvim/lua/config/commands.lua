vim.api.nvim_create_user_command('Configurations', function()
  local CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'
  vim.api.nvim_set_current_dir(CONFIG_HOME)
end, {})

local selected_pane = nil

local function get_pane_list()
  local handle = io.popen('wezterm cli list --format json')
  if handle then
    local result = handle:read('*a')
    handle:close()
    local panes = vim.fn.json_decode(result)
    local pane_list = {}
    for _, pane in ipairs(panes) do
      table.insert(pane_list, {
        id = pane.pane_id,
        description = string.format('ID: %d - %s', pane.pane_id, pane.title or 'No Title'),
      })
    end
    return pane_list
  else
    vim.notify('Failed to get pane list', vim.log.levels.ERROR)
    return {}
  end
end

vim.api.nvim_create_user_command('SelectWezPane', function()
  if vim.fn.executable('wezterm') ~= 1 then
    return
  end

  local pane_list = get_pane_list()
  if #pane_list == 0 then
    vim.notify('No panes available', vim.log.levels.WARN)
    return
  end

  vim.ui.select(pane_list, {
    prompt = 'Select a WezTerm Pane:',
    format_item = function(item)
      return item.description
    end,
  }, function(selected)
    if selected then
      selected_pane = selected.id
      vim.notify(string.format('Selected Pane ID: %d', selected_pane), vim.log.levels.INFO)
    else
      vim.notify('No pane selected', vim.log.levels.WARN)
    end
  end)
end, {})

vim.api.nvim_create_user_command('PasteSelectionWezPane', function()
  if vim.fn.executable('wezterm') ~= 1 then
    return
  end
  if vim.fn.mode() == 'n' then
    vim.cmd('normal! "vyy') -- Yank the selected text to register "v"
  elseif string.lower(vim.fn.mode()) == 'v' then
    vim.cmd('normal! "vy')
  end

  local selection = vim.fn.getreg('v') -- Get the yanked text

  -- Send the selection to WezTerm using wezterm cli
  local wezterm_cmd = string.format('wezterm cli send-text --no-paste --pane-id %s ', selected_pane)

  vim.fn.system(wezterm_cmd, selection)
  vim.fn.system(wezterm_cmd, '\n')
end, { range = true })
