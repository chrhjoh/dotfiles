local utils = require('ui.tabline.utils')
local colors = require('utils.colors').colors
local wezterm = require('wezterm') --[[@ as Wezterm]]
local symbols = wezterm.nerdfonts
local M = {}

---@param tab TabInformation
---@return string
local function get_active_tab_name(tab)
  local title = tab.tab_title

  -- If title is set
  if title and #title > 0 then
    return title
  end

  -- Try and get it from the active panes directory
  local cwd_uri = tab.active_pane.current_working_dir
  if cwd_uri then
    local parent = cwd_uri.file_path:match('([^/]*)/[^/]*$')
    local cwd = cwd_uri.file_path:match('([^/]+)/?$')
    title = parent .. '/' .. cwd
    return title
  end

  return tab.active_pane.title
end

---@param tab TabInformation
---@param tabs TabInformation[]
---@param panes Pane[]
---@param config Config
---@param hover bool
---@param max_width number
---@return string
function M.build_active_title(tab, tabs, panes, config, hover, max_width)
  local name = get_active_tab_name(tab)
  local index = tab.tab_index + 1 .. '. '
  local zoom

  if tab.active_pane.is_zoomed then
    zoom = ' ' .. symbols.cod_zoom_in .. ' '
  else
    zoom = ''
  end

  local right_symbol = utils.format_text(symbols.ple_right_half_circle_thick, colors.mauve, colors.base)
  local left_symbol = utils.format_text(symbols.ple_left_half_circle_thick, colors.mauve, colors.base)

  if name:len() > max_width - 1 then
    wezterm.log_error(name .. ' ' .. name:len())
    name = wezterm.truncate_right(name, 20) .. '..'
  end

  return left_symbol .. index .. name .. zoom .. right_symbol
end

---@param tab TabInformation
---@param tabs TabInformation[]
---@param panes Pane[]
---@param config Config
---@param hover bool
---@param max_width number
---@return string
function M.build_inactive_title(tab, tabs, panes, config, hover, max_width)
  local index = tab.tab_index + 1 .. '. '

  local right_symbol
  local left_symbol
  local foreground_process_name
  local icon_str
  -- get the foreground process name if available

  if tab.active_pane and tab.active_pane.foreground_process_name then
    foreground_process_name = tab.active_pane.foreground_process_name
    foreground_process_name = foreground_process_name:match('([^/\\]+)[/\\]?$') or foreground_process_name
  end

  -- fallback to the title if the foreground process name is unavailable
  -- Wezterm uses OSC 1/2 escape sequences to guess the process name and set the title
  -- see https://wezfurlong.org/wezterm/config/lua/pane/get_title.html
  -- title defaults to 'wezterm' if another name is unavailable
  if foreground_process_name == '' then
    foreground_process_name = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  end

  -- if the tab active pane contains a non-local domain, use the domain name
  if foreground_process_name == 'wezterm' then
    foreground_process_name = tab.active_pane.domain_name ~= 'local' and tab.active_pane.domain_name or 'wezterm'
  end
  local name = index .. foreground_process_name

  local icon = utils.process_to_icon[foreground_process_name]

  if icon == nil then
    icon = utils.process_to_icon['default']
  end

  if hover then
    name = utils.format_text(name, nil, colors.surface1)
    icon_str = utils.format_text(icon.symbol .. '  ', icon.foreground, colors.surface1)
    right_symbol = utils.format_text(symbols.ple_right_half_circle_thick, colors.surface1)
    left_symbol = utils.format_text(symbols.ple_left_half_circle_thick, colors.surface1)
  else
    icon_str = utils.format_text(icon.symbol .. '  ', icon.foreground, colors.base)
    right_symbol = utils.format_text(symbols.ple_right_half_circle_thick, colors.base, colors.base)
    left_symbol = utils.format_text(symbols.ple_left_half_circle_thick, colors.base, colors.base)
  end

  return left_symbol .. icon_str .. name .. right_symbol
end

return M
