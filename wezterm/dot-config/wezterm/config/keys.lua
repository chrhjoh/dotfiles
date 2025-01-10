local wezterm = require('wezterm') --[[@as Wezterm]]
local copy_paste = require('plugins.copy')
local actions = wezterm.action

local M = {}

---@param config Config
local function key_configurations(config)
  config.disable_default_key_bindings = true
  config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }
  config.skip_close_confirmation_for_processes_named = {}
  config.keys = {
    { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'Space', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'Space', mods = 'CTRL' } },
    {
      key = 'r',
      mods = 'LEADER',
      action = actions.ActivateKeyTable { name = 'resize_pane', one_shot = false },
    },
    {
      key = 's',
      mods = 'LEADER',
      action = actions.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES', title = 'Select workspace' },
    },
    {
      key = 's',
      mods = 'LEADER|SHIFT',
      action = actions.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace - Enter for Current Working Directory' },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line == '' then
            window:perform_action(
              actions.SwitchToWorkspace {
                name = window:active_pane():get_current_working_dir(),
              },
              pane
            )
          elseif line ~= nil then
            window:perform_action(
              actions.SwitchToWorkspace {
                name = line,
              },
              pane
            )
          end
        end),
      },
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
    { key = 'W', mods = 'SUPER|SHIFT', action = actions.CloseCurrentTab { confirm = true } },
    { key = 'E', mods = 'SUPER', action = actions.CloseCurrentPane { confirm = true } },
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
    { key = '/', mods = 'SHIFT|CTRL', action = wezterm.action.QuickSelect },
    {
      key = 'u',
      mods = 'LEADER',
      action = actions.AttachDomain('unix'),
    },
    {
      key = 'U',
      mods = 'LEADER',
      action = actions.DetachDomain { DomainName = 'unix' },
    },
    { key = 'h', mods = 'CTRL|SHIFT', action = actions.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'CTRL|SHIFT', action = actions.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'CTRL|SHIFT', action = actions.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'CTRL|SHIFT', action = actions.ActivatePaneDirection('Right') },
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
    {
      key = '?',
      mods = 'LEADER',
      action = actions.SpawnCommandInNewTab { args = { 'bash', '-ic', 'wezterm show-keys | fzf' } },
    },
    { key = 'D', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
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
  config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
  }
end

---@param config Config
function M.setup(config)
  key_configurations(config)
end

return M
