local wezterm = require('wezterm')
M = {}

local function basename(s)
	s, _ = string.gsub(s, '(.*[/\\])(.*)', '%2')
	return s
end

wezterm.on('update-status', function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Process/domain name
	local process = pane:get_domain_name()
	if process == 'local' then
		process = pane:get_foreground_process_name()
	end
	table.insert(cells, basename(process))


	-- Insert workspace name
	table.insert(cells, window:active_workspace())
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		if cwd_uri.file_path then
			table.insert(cells, basename(cwd_uri.file_path))
		end
		if cwd_uri.host then
			table.insert(cells, cwd_uri.host)
		else
			table.insert(cells, wezterm.hostname())
		end
	end


	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime '%a %b %-d %H:%M'
	table.insert(cells, date)

	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = "█"
	local BACKGROUND_COLOR = "#313244"
	local TEXT_FG = '#cdd6f4'
	local ICON_FG = "#000000"


	-- Color palette for the backgrounds of each cell
	local colors = {
		'#eba0ac',
		'#a6e3a1',
		'#cba6f7',
		'#cba6f7',
		'#89b4fa',
	}

	local icons = {
		"",
		"",
		"",
		"󰒋",
		"󰃰"
	}

	-- Foreground color for the text across the fade

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1

		table.insert(elements, { Foreground = { Color = ICON_FG } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = ' ' .. icons[cell_no] .. ' ' })

		table.insert(elements, { Foreground = { Color = TEXT_FG } })
		table.insert(elements, { Background = { Color = BACKGROUND_COLOR } })
		table.insert(elements, { Text = ' ' .. text .. ' ' })

		if not is_last then
			table.insert(elements, { Foreground = { Color = BACKGROUND_COLOR } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

function M.add_tab_bar_configurations(config)
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = false
	config.hide_tab_bar_if_only_one_tab = false
end

return M
