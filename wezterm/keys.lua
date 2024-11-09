local wezterm = require('wezterm')
local act = wezterm.action

M = {}

function M.add_key_configurations(config)
	config.disable_default_key_bindings = true
	config.leader = { key = 'Space', mods = 'CTRL|SHIFT', timeout_milliseconds = 2000 }
	config.skip_close_confirmation_for_processes_named = {}
	config.keys = {
		{ key = '|',     mods = 'LEADER|SHIFT',      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
		{ key = '-',     mods = 'LEADER',            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, },
		-- Send "CTRL-Space" to the terminal when pressing CTRL-Space, CTRL-Space
		{ key = 'Space', mods = 'LEADER|CTRL|SHIFT', action = wezterm.action.SendKey { key = 'Space', mods = 'CTRL|SHIFT' }, },
		-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
		-- mode until we cancel that mode.
		{ key = 'r',     mods = 'LEADER',            action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false }, },
		-- Move around Panes
		{ key = 'h',     mods = 'SHIFT|CTRL',        action = act.ActivatePaneDirection 'Left' },
		{ key = 'l',     mods = 'SHIFT|CTRL',        action = act.ActivatePaneDirection 'Right' },
		{ key = 'k',     mods = 'SHIFT|CTRL',        action = act.ActivatePaneDirection 'Up' },
		{ key = 'j',     mods = 'SHIFT|CTRL',        action = act.ActivatePaneDirection 'Down' },

		{ key = 's',     mods = 'LEADER',            action = act.ShowLauncherArgs { flags = 'WORKSPACES', title = "Select workspace" }, },
		-- Rename workspace
		{
			key = 'N',
			mods = 'LEADER',
			action = act.PromptInputLine {
				description = '(wezterm) Set workspace title:',
				action = wezterm.action_callback(function(win, pane, line)
					if line then
						wezterm.mux.rename_workspace(
							wezterm.mux.get_active_workspace(),
							line
						)
						wezterm.emit('update-status')
					end
				end) }
		},
		-- Rename Tab
		{
			key = 'n',
			mods = 'LEADER',
			action = act.PromptInputLine {
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
		{ key = 'L', mods = 'SHIFT|ALT',    action = act.ActivateTabRelative(1) },
		{ key = 'H', mods = 'SHIFT|ALT',    action = act.ActivateTabRelative(-1) },
		{ key = '+', mods = 'CTRL',         action = act.IncreaseFontSize },
		{ key = '+', mods = 'SHIFT|CTRL',   action = act.IncreaseFontSize },
		{ key = '-', mods = 'CTRL',         action = act.DecreaseFontSize },
		{ key = '-', mods = 'SHIFT|CTRL',   action = act.DecreaseFontSize },
		{ key = '-', mods = 'SUPER',        action = act.DecreaseFontSize },
		{ key = '0', mods = 'CTRL',         action = act.ResetFontSize },
		{ key = '0', mods = 'SHIFT|CTRL',   action = act.ResetFontSize },
		{ key = '0', mods = 'SUPER',        action = act.ResetFontSize },
		{ key = 'C', mods = 'SHIFT|CTRL',   action = act.CopyTo 'Clipboard' },
		{ key = 'F', mods = 'SHIFT|CTRL',   action = act.Search 'CurrentSelectionOrEmptyString' },
		{ key = 'M', mods = 'SHIFT|CTRL',   action = act.Hide },
		{ key = 'P', mods = 'SHIFT|CTRL',   action = act.ActivateCommandPalette },
		{ key = 'Q', mods = 'SHIFT|CTRL',   action = act.QuitApplication },
		{ key = 'R', mods = 'SHIFT|CTRL',   action = act.ReloadConfiguration },
		{ key = 'U', mods = 'SHIFT|CTRL',   action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
		{ key = 'V', mods = 'SHIFT|CTRL',   action = act.PasteFrom 'Clipboard' },
		{ key = 'W', mods = 'SHIFT|CTRL',   action = act.CloseCurrentTab { confirm = true } },
		{ key = 'E', mods = 'SHIFT|CTRL',   action = act.CloseCurrentPane { confirm = true } },
		{ key = 'X', mods = 'SHIFT|CTRL',   action = act.ActivateCopyMode },
		{ key = 'Z', mods = 'SHIFT|CTRL',   action = act.TogglePaneZoomState },
		{ key = 'c', mods = 'SUPER',        action = act.CopyTo 'Clipboard' },
		{ key = 'f', mods = 'SUPER',        action = act.Search 'CurrentSelectionOrEmptyString' },
		{ key = 'h', mods = 'SUPER',        action = act.HideApplication },
		{ key = 'k', mods = 'SUPER',        action = act.ClearScrollback 'ScrollbackOnly' },
		{ key = 'm', mods = 'SUPER',        action = act.Hide },
		{ key = 'q', mods = 'SUPER',        action = act.QuitApplication },
		{ key = 'r', mods = 'SUPER',        action = act.ReloadConfiguration },
		{ key = 'v', mods = 'SUPER',        action = act.PasteFrom 'Clipboard' },
		{ key = 'v', mods = 'ALT',          action = act.PasteFrom 'PrimarySelection' },
		{ key = 'k', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true } },
		{ key = 'k', mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
		{ key = 'c', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
		{
			key = 'u',
			mods = 'LEADER',
			action = act.AttachDomain 'unix',
		},
		{
			key = 'U',
			mods = 'LEADER',
			action = act.SpawnTab { DomainName = 'unix' }
		},

		{
			key = 'd',
			mods = 'LEADER',
			action = act.DetachDomain 'CurrentPaneDomain',
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
			{ key = 'h',      action = act.AdjustPaneSize { 'Left', 1 } },
			{ key = 'l',      action = act.AdjustPaneSize { 'Right', 1 } },
			{ key = 'k',      action = act.AdjustPaneSize { 'Up', 1 } },
			{ key = 'j',      action = act.AdjustPaneSize { 'Down', 1 } },

			-- Cancel the mode by pressing escape
			{ key = 'Escape', action = 'PopKeyTable' },
		},

	}
end

return M
