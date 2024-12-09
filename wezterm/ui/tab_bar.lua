local wezterm = require('wezterm') --[[@as Wezterm]]
local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')
local M = {}

local function domain_component(window)
  local domain = window:active_pane():get_domain_name()
  return ' ' .. wezterm.nerdfonts.md_domain .. ' ' .. domain .. ' '
end

local function extended_hostname_component(window)
  local cwd_uri = window:active_pane():get_current_working_dir()
  local hostname = ''

  if window:leader_is_active() then
    hostname = 'LEADER'
  elseif cwd_uri == nil then
    hostname = wezterm.hostname()
  elseif type(cwd_uri) == 'userdata' then
    hostname = cwd_uri.host or wezterm.hostname()
  else
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find('/')
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
    end
  end

  local dot = hostname:find('[.]')
  if dot then
    hostname = hostname:sub(1, dot - 1)
  end

  return ' ' .. hostname .. ' '
end
---@param config Config
function M.setup(config)
  tabline.setup {
    options = {
      icons_enabled = true,
      theme = 'Catppuccin Mocha',
      section_separators = {
        left = '',
        right = '',
      },
      component_separators = {
        left = ' |',
        right = '|',
      },
      tab_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick .. ' ',
        right = ' ' .. wezterm.nerdfonts.ple_left_half_circle_thick,
      },
      color_overrides = {
        -- Default tab colors
        normal_mode = {
          b = { fg = '#cdd6f4', bg = '#313244' },
        },
        tab = {
          active = { fg = '#181825', bg = '#cba6f7' },
          inactive = { fg = '#cdd6f4' },
          inactive_hover = { fg = '#f5c2e7', bg = '#6c7086' },
        },
      },
    },
    sections = {
      tabline_a = { domain_component },
      tabline_b = { 'workspace' },
      tabline_c = { ' ' },
      tab_active = {
        {
          'index',
          fmt = function(text, window)
            return text .. ':'
          end,
        },
        { 'parent', padding = 0 },
        '/',
        { 'cwd', padding = { left = 0, right = 1 } },
        { 'zoomed', padding = 0 },
      },
      tab_inactive = {
        {
          'index',
          fmt = function(text, window)
            return text .. ':'
          end,
        },
        { 'process', padding = { left = 0, right = 1 } },
      },
      tabline_x = { 'ram', 'cpu' },
      tabline_y = {},
      tabline_z = { extended_hostname_component },
    },
    extensions = {},
  }
  tabline.apply_to_config(config)
end

return M
