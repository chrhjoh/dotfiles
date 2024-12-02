local wezterm = require('wezterm')
local act = wezterm.action

M = {}

local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then return false end

	local success, stdout, stderr = wezterm.run_child_process
	    { 'sh', '-c',
		    'ps -o state= -o comm= -t' .. wezterm.shell_quote_arg(tty) .. ' | ' ..
		    'grep -iqE \'^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$\'' }

	return success
end
local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if is_inside_vim(pane) or os.getenv("TMUX") then
		window:perform_action(
		-- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = 'CTRL' }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

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

function M.add_key_configurations(config)
	config.disable_default_key_bindings = true
	config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }
	config.skip_close_confirmation_for_processes_named = {}
	config.keys = {
		{ key = '|',     mods = 'LEADER|SHIFT',      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
		{ key = '-',     mods = 'LEADER',            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }, },
		-- Send "CTRL-Space" to the terminal when pressing CTRL-Space, CTRL-Space
		{ key = 'Space', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'Space', mods = 'CTRL' }, },
		-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
		-- mode until we cancel that mode.
		{ key = 'r',     mods = 'LEADER',            action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false }, },
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
		{ key = 'l', mods = 'ALT',    action = act.ActivateTabRelative(1) },
		{ key = 'h', mods = 'ALT',    action = act.ActivateTabRelative(-1) },
		{ key = '+', mods = 'CTRL',         action = act.IncreaseFontSize },
		{ key = '-', mods = 'CTRL',         action = act.DecreaseFontSize },
		{ key = '-', mods = 'SUPER',        action = act.DecreaseFontSize },
		{ key = '0', mods = 'CTRL',         action = act.ResetFontSize },
		{ key = '0', mods = 'SUPER',        action = act.ResetFontSize },
		{ key = 'C', mods = 'CTRL',   action = act.CopyTo 'Clipboard' },
		{ key = 'F', mods = 'CTRL',   action = act.Search 'CurrentSelectionOrEmptyString' },
		{ key = 'M', mods = 'CTRL',   action = act.Hide },
		{ key = 'P', mods = 'CTRL',   action = act.ActivateCommandPalette },
		{ key = 'Q', mods = 'CTRL',   action = act.QuitApplication },
		{ key = 'R', mods = 'CTRL',   action = act.ReloadConfiguration },
		{ key = 'U', mods = 'CTRL',   action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
		{ key = 'V', mods = 'CTRL',   action = act.PasteFrom 'Clipboard' },
		{ key = 'W', mods = 'CTRL',   action = act.CloseCurrentTab { confirm = true } },
		{ key = 'E', mods = 'CTRL',   action = act.CloseCurrentPane { confirm = true } },
		{ key = 'X', mods = 'CTRL',   action = act.ActivateCopyMode },
		{ key = 'Z', mods = 'CTRL',   action = act.TogglePaneZoomState },
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
		{ key = 't', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
		{
			key = 'a',
			mods = 'LEADER',
			action = act.AttachDomain 'unix',
		},
		{
			key = 'd',
			mods = 'LEADER',
			action = act.DetachDomain 'CurrentPaneDomain',
		},
		{ key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-left') },
		{ key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-down') },
		{ key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-up') },
		{ key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-right') }, }
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
