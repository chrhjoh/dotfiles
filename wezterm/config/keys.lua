local wezterm = require('wezterm') --[[@as Wezterm]]
local copy_paste = require('utils.copy')
local actions = wezterm.action

local M = {}

---@param pane Pane
---@return boolean
local function is_inside_vim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then
    return false
  end

  local success, stdout, stderr = wezterm.run_child_process {
    'sh',
    '-c',
    'ps -o state= -o comm= -t'
      .. wezterm.shell_quote_arg(tty)
      .. ' | '
      .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
  }

  return success
end

---@param window Window
---@param pane Pane
---@param pane_direction Direction
---@param vim_direction string
local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if is_inside_vim(pane) or os.getenv('TMUX') then
    window:perform_action(
      -- This should match the keybinds you set in Neovim.
      actions.SendKey { key = vim_direction, mods = 'CTRL' },
      pane
    )
  else
    window:perform_action(actions.ActivatePaneDirection(pane_direction), pane)
  end
end

---@param config Config
local function key_configurations(config)
  config.disable_default_key_bindings = true
  config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }
  config.skip_close_confirmation_for_processes_named = {}
  config.keys = {
    { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- Send "CTRL-Space" to the terminal when pressing CTRL-Space, CTRL-Space
    { key = 'Space', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'Space', mods = 'CTRL' } },
    -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
    -- mode until we cancel that mode.
    {
      key = 'r',
      mods = 'LEADER',
      action = actions.ActivateKeyTable { name = 'resize_pane', one_shot = false },
    },
    {
      key = 's',
      mods = 'LEADER',
      action = actions.ShowLauncherArgs { flags = 'WORKSPACES', title = 'Select workspace' },
    },
    -- Rename workspace
    {
      key = 'N',
      mods = 'LEADER',
      action = actions.PromptInputLine {
        description = '(wezterm) Set workspace title:',
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
            wezterm.emit('update-status')
          end
        end),
      },
    },
    -- Rename Tab
    {
      key = 'n',
      mods = 'LEADER',
      action = actions.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
          wezterm.emit('update-status')
        end),
      },
    },

    -- Default Keybindings
    { key = 'l', mods = 'ALT', action = actions.ActivateTabRelative(1) },
    { key = 'h', mods = 'ALT', action = actions.ActivateTabRelative(-1) },
    { key = '+', mods = 'CTRL', action = 'IncreaseFontSize' },
    { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
    { key = '-', mods = 'SUPER', action = 'DecreaseFontSize' },
    { key = '0', mods = 'CTRL', action = 'ResetFontSize' },
    { key = '0', mods = 'SUPER', action = 'ResetFontSize' },
    { key = 'C', mods = 'CTRL', action = actions.CopyTo('Clipboard') },
    { key = 'F', mods = 'CTRL', action = actions.Search('CurrentSelectionOrEmptyString') },
    { key = 'M', mods = 'CTRL', action = 'Hide' },
    { key = 'P', mods = 'CTRL', action = 'ActivateCommandPalette' },
    { key = 'Q', mods = 'CTRL', action = 'QuitApplication' },
    { key = 'R', mods = 'CTRL', action = 'ReloadConfiguration' },
    {
      key = 'U',
      mods = 'CTRL',
      action = actions.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' },
    },
    { key = 'V', mods = 'CTRL', action = actions.PasteFrom('Clipboard') },
    { key = 'W', mods = 'CTRL', action = actions.CloseCurrentTab { confirm = true } },
    { key = 'E', mods = 'CTRL', action = actions.CloseCurrentPane { confirm = true } },
    { key = 'X', mods = 'CTRL', action = 'ActivateCopyMode' },
    { key = 'Z', mods = 'CTRL', action = 'TogglePaneZoomState' },
    { key = 'c', mods = 'SUPER', action = actions.CopyTo('Clipboard') },
    { key = 'f', mods = 'SUPER', action = actions.Search('CurrentSelectionOrEmptyString') },
    { key = 'h', mods = 'SUPER', action = 'HideApplication' },
    { key = 'k', mods = 'SUPER', action = actions.ClearScrollback('ScrollbackOnly') },
    { key = 'm', mods = 'SUPER', action = 'Hide' },
    { key = 'q', mods = 'SUPER', action = 'QuitApplication' },
    { key = 'r', mods = 'SUPER', action = 'ReloadConfiguration' },
    { key = 'v', mods = 'SUPER', action = actions.PasteFrom('Clipboard') },
    { key = 'v', mods = 'ALT', action = actions.PasteFrom('PrimarySelection') },
    { key = 'k', mods = 'LEADER|SHIFT', action = actions.CloseCurrentTab { confirm = true } },
    { key = 'k', mods = 'LEADER', action = actions.CloseCurrentPane { confirm = true } },
    { key = 't', mods = 'LEADER', action = actions.SpawnTab('CurrentPaneDomain') },
    {
      key = 'a',
      mods = 'LEADER',
      action = actions.AttachDomain('unix'),
    },
    {
      key = 'd',
      mods = 'LEADER',
      action = actions.DetachDomain('CurrentPaneDomain'),
    },
    { key = 'h', mods = 'CTRL', action = actions.EmitEvent('ActivatePaneDirection-left') },
    { key = 'j', mods = 'CTRL', action = actions.EmitEvent('ActivatePaneDirection-down') },
    { key = 'k', mods = 'CTRL', action = actions.EmitEvent('ActivatePaneDirection-up') },
    { key = 'l', mods = 'CTRL', action = actions.EmitEvent('ActivatePaneDirection-right') },
    {
      key = 'I',
      mods = 'LEADER',
      action = actions.PaneSelect {
        show_pane_ids = true,
      },
    },
    {
      key = 'm',
      mods = 'LEADER',
      action = actions.PaneSelect {
        mode = 'SwapWithActive',
      },
    },
    {
      key = 'P',
      mods = 'LEADER',
      action = actions.EmitEvent(copy_paste.set_paste_terminal_event),
    },
    {
      key = 'p',
      mods = 'LEADER',
      action = actions.EmitEvent(copy_paste.paste_selection_event),
    },
  }
  config.key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = 'h', action = actions.AdjustPaneSize { 'Left', 1 } },
      { key = 'l', action = actions.AdjustPaneSize { 'Right', 1 } },
      { key = 'k', action = actions.AdjustPaneSize { 'Up', 1 } },
      { key = 'j', action = actions.AdjustPaneSize { 'Down', 1 } },

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
  }
end

---@param config Config
function M.setup(config)
  wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
  end)
  wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
  end)
  wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
  end)
  wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
  end)
  key_configurations(config)
end

return M
