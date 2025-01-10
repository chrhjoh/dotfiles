local wezterm = require('wezterm') --[[@as Wezterm]]
local symbols = wezterm.nerdfonts
local colors = require('utils.colors').colors
local scheme = require('config.colorscheme').scheme
local M = {}

---@param window Window
---@return string
function M.resolve_hostname(window)
  local cwd_uri = window:active_pane():get_current_working_dir()
  local hostname = ''

  if cwd_uri == nil then
    hostname = wezterm.hostname()
  elseif type(cwd_uri) == 'userdata' then
    hostname = cwd_uri.host or wezterm.hostname()
  else
    cwd_uri = string.sub(cwd_uri.path, 8)
    local slash = cwd_uri:find('/')
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
    end
  end

  local dot = hostname:find('[.]')
  if dot then
    hostname = hostname:sub(1, dot - 1)
  end

  return hostname
end

---@param mode string
---@return string
function M.color_by_mode(mode)
  local color_map = {
    NORMAL = colors.blue,
    COPY = colors.yellow,
    SEARCH = colors.green,
    LEADER = colors.red,
  }
  local color = color_map[mode]
  if color == nil then
    return color_map.NORMAL
  end
  return color
end

---@param window Window
---@return string
function M.get_current_mode(window)
  local key_table = window:active_key_table()

  if window:leader_is_active() then
    return 'LEADER'
  end
  if key_table == nil or not key_table:find('_mode$') then
    key_table = 'normal_mode'
  end
  return key_table:gsub('_mode', ''):upper()
end

local cache_result_cpu = '0'
local time_cpu_update = 0

---@param update_time integer
---@return string
function M.cpu_usage(update_time)
  local current_time = os.time()
  if current_time - time_cpu_update < update_time then
    return cache_result_cpu
  end

  local success, stdout, stderr = wezterm.run_child_process {
    'bash',
    '-c',
    "iostat -c 2 disk0 | sed '/^\\s*$/d' | tail -n 1 | awk -v format='%3.1f%%' '{usage=100-$6} END {printf(format, usage)}' | sed 's/,/./'",
  }
  time_cpu_update = current_time

  if success then
    cache_result_cpu = stdout
    return stdout
  end
  wezterm.log_info('DID not work')
  return cache_result_cpu
end

---@param result string
---@return string
local function parse_ram(result)
  local page_size = result:match('page size of (%d+) bytes')
  local pages_free = result:match('Pages free: +(%d+).')
  local pages_active = result:match('Pages active: +(%d+).')
  local pages_inactive = result:match('Pages inactive: +(%d+).')
  local pages_speculative = result:match('Pages speculative: +(%d+).')
  local total_memory = (pages_free + pages_active + pages_inactive + pages_speculative) * page_size / 1024 / 1024 / 1024
  return string.format('%.2f GB', total_memory)
end

local cache_result_ram = '0'
local time_ram_update = 0

---@param update_time integer
---@return string
function M.ram_usage(update_time)
  local current_time = os.time()
  if current_time - time_ram_update < update_time then
    return cache_result_ram
  end

  local success, stdout, stderr = wezterm.run_child_process {
    'vm_stat',
  }
  time_ram_update = current_time
  if success then
    cache_result_ram = parse_ram(stdout)
    return cache_result_ram
  end
  wezterm.log_info('ramDID not work')

  return cache_result_ram
end

---@param text string
---@param left integer
---@param right integer?
---@param pad_str string?
function M.pad(text, left, right, pad_str)
  if right == nil then
    right = left
  end
  if pad_str == nil then
    pad_str = ' '
  end
  return string.rep(pad_str, left) .. text .. string.rep(pad_str, right)
end

---@param text string
---@param foreground string?
---@param background string?
---@param underline string?
---@param intensity string?
---@param italic bool?
---@return string
function M.format_text(text, foreground, background, underline, intensity, italic)
  local items = {}
  if foreground ~= nil then
    table.insert(items, { Foreground = { Color = foreground } })
  end
  if background ~= nil then
    table.insert(items, { Background = { Color = background } })
  end

  if underline ~= nil then
    table.insert(items, { Attribute = { Underline = underline } })
  end

  if intensity ~= nil then
    table.insert(items, { Attribute = { Intensity = intensity } })
  end

  if italic ~= nil then
    table.insert(items, { Attribute = { Italic = italic } })
  end

  table.insert(items, { Text = text })
  return wezterm.format(items)
end

M.process_to_icon = {
  ['air'] = { symbol = symbols.md_language_go, foreground = scheme.brights[5] },
  ['apt'] = { symbol = symbols.dev_debian, foreground = scheme.ansi[2] },
  ['bacon'] = { symbol = symbols.dev_rust, foreground = scheme.ansi[2] },
  ['bash'] = { symbol = symbols.cod_terminal_bash, foreground = scheme.cursor_bg },
  ['bat'] = { symbol = symbols.md_bat, foreground = scheme.ansi[5] },
  ['btm'] = { symbol = symbols.md_chart_donut_variant, foreground = scheme.ansi[2] },
  ['btop'] = { symbol = symbols.md_chart_areaspline, foreground = scheme.ansi[2] },
  ['btop4win++'] = { symbol = symbols.md_chart_areaspline, foreground = scheme.ansi[2] },
  ['bun'] = { symbol = symbols.md_hamburger, foreground = scheme.cursor_bg },
  ['cargo'] = { symbol = symbols.dev_rust, foreground = scheme.ansi[2] },
  ['chezmoi'] = { symbol = symbols.md_home_plus_outline, foreground = scheme.brights[5] },
  ['cmd.exe'] = { symbol = symbols.md_console_line, foreground = scheme.cursor_bg },
  ['curl'] = { symbol = symbols.md_curling, foreground = scheme.cursor_bg },
  ['debug'] = { symbol = symbols.cod_debug, foreground = scheme.ansi[5] },
  ['default'] = { symbol = symbols.md_application, foreground = scheme.cursor_bg },
  ['docker'] = { symbol = symbols.linux_docker, foreground = scheme.ansi[5] },
  ['docker-compose'] = { symbol = symbols.linux_docker, foreground = scheme.ansi[5] },
  ['dpkg'] = { symbol = symbols.dev_debian, foreground = scheme.ansi[2] },
  ['fish'] = { symbol = symbols.md_fish, foreground = scheme.cursor_bg },
  ['gh'] = { symbol = symbols.dev_github_badge, foreground = scheme.indexed[16] },
  ['git'] = { symbol = symbols.dev_git, foreground = scheme.indexed[16] },
  ['go'] = { symbol = symbols.md_language_go, foreground = scheme.brights[5] },
  ['htop'] = { symbol = symbols.md_chart_areaspline, foreground = scheme.ansi[2] },
  ['kubectl'] = { symbol = symbols.linux_docker, foreground = scheme.ansi[5] },
  ['kuberlr'] = { symbol = symbols.linux_docker, foreground = scheme.ansi[5] },
  ['lazydocker'] = { symbol = symbols.linux_docker, foreground = scheme.ansi[5] },
  ['lazygit'] = { symbol = symbols.cod_github, foreground = scheme.indexed[16] },
  ['lua'] = { symbol = symbols.seti_lua, foreground = scheme.ansi[5] },
  ['make'] = { symbol = symbols.seti_makefile, foreground = scheme.cursor_bg },
  ['nix'] = { symbol = symbols.linux_nixos, foreground = scheme.ansi[5] },
  ['node'] = { symbol = symbols.md_nodejs, foreground = scheme.brights[2] },
  ['npm'] = { symbol = symbols.md_npm, foreground = scheme.brights[2] },
  ['nvim'] = { symbol = symbols.custom_neovim, foreground = scheme.ansi[3] },
  ['pacman'] = { symbol = symbols.md_pac_man, foreground = scheme.ansi[4] },
  ['paru'] = { symbol = symbols.md_pac_man, foreground = scheme.ansi[4] },
  ['pnpm'] = { symbol = symbols.md_npm, foreground = scheme.brights[4] },
  ['postgresql'] = { symbol = symbols.dev_postgresql, foreground = scheme.ansi[5] },
  ['powershell.exe'] = { symbol = symbols.md_console, foreground = scheme.cursor_bg },
  ['psql'] = { symbol = symbols.dev_postgresql, foreground = scheme.ansi[5] },
  ['pwsh.exe'] = { symbol = symbols.md_console, foreground = scheme.cursor_bg },
  ['rpm'] = { symbol = symbols.dev_redhat, foreground = scheme.ansi[2] },
  ['redis'] = { symbol = symbols.dev_redis, foreground = scheme.ansi[5] },
  ['ruby'] = { symbol = symbols.cod_ruby, foreground = scheme.brights[2] },
  ['rust'] = { symbol = symbols.dev_rust, foreground = scheme.ansi[2] },
  ['serial'] = { symbol = symbols.md_serial_port, foreground = scheme.cursor_bg },
  ['ssh'] = { symbol = symbols.md_pipe, foreground = scheme.cursor_bg },
  ['sudo'] = { symbol = symbols.fa_hashtag, foreground = scheme.cursor_bg },
  ['tls'] = { symbol = symbols.md_power_socket, foreground = scheme.cursor_bg },
  ['topgrade'] = { symbol = symbols.md_rocket_launch, foreground = scheme.ansi[5] },
  ['unix'] = { symbol = symbols.md_bash, foreground = scheme.cursor_bg },
  ['valkey'] = { symbol = symbols.dev_redis, foreground = scheme.brights[5] },
  ['vim'] = { symbol = symbols.dev_vim, foreground = scheme.ansi[3] },
  ['wget'] = symbols.md_arrow_down_box,
  ['yarn'] = { symbol = symbols.seti_yarn, foreground = scheme.ansi[5] },
  ['yay'] = { symbol = symbols.md_pac_man, foreground = scheme.ansi[4] },
  ['yazi'] = { symbol = symbols.md_duck, foreground = scheme.indexed[16] },
  ['yum'] = { symbol = symbols.dev_redhat, foreground = scheme.ansi[2] },
  ['zsh'] = { symbol = symbols.dev_terminal, foreground = scheme.cursor_bg },
}

return M
