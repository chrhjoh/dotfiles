---@class CoreSession
local M = {}

local _active = false

local save_dir = vim.fn.stdpath("data") .. "/sessions/"
local augroup = "session_tracker"
local function should_save()
  local ignored_buftypes = { "snacks_dashboard", "gitcommit" }
  local root_markers = { ".git", "package.json", "Cargo.toml", "pyproject.toml" }

  local cwd = vim.fn.getcwd()

  if cwd ~= vim.fs.root(cwd, root_markers) then
    return false
  end

  local bufs = vim.fn.getbufinfo { buflisted = 1 }
  bufs = vim.tbl_filter(function(buf)
    return not vim.tbl_contains(ignored_buftypes, vim.bo[buf.bufnr].buftype)
      and vim.api.nvim_buf_get_name(buf.bufnr) ~= ""
  end, bufs)

  if #bufs < 1 then
    return false
  end

  return true
end

local e = vim.fn.fnameescape

---@param loaded boolean
local function default_callback(loaded)
  if not loaded then
    Snacks.picker.files()
  end
end

---@param path string
---@return string
local function safe_path(path)
  path = path:gsub("[\\/:]+", "%%")
  return path
end

---@param dir string?
---@return string?
local function resolve_branch(dir)
  dir = dir and dir .. "/" or ""
  local git_dir = dir .. ".git"
  if vim.uv.fs_stat(git_dir) then
    local ret = vim.fn.systemlist { "git", "--git-dir", git_dir, "branch", "--show-current" }
    return vim.v.shell_error == 0 and ret[1] or nil
  end
end

---@param dir? string
---@return {dir: string, file: string}
local function resolve_session(dir)
  if not dir then
    local last_session = M.list()[1]
    return { file = last_session.session, dir = last_session.dir }
  end

  local name = safe_path(dir)
  local branch = resolve_branch(dir)

  if branch then
    branch = safe_path(branch)
    name = name .. "@@" .. branch
  end

  return { file = save_dir .. name .. ".vim", dir = dir }
end

function M.is_active()
  return _active
end

function M.toggle()
  if _active then
    M.untrack()
  else
    M.track()
  end
end

function M.track()
  _active = true
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup(augroup, { clear = true }),
    callback = function()
      if should_save() and M.is_active() then
        M.save()
      end
    end,
  })
end

function M.untrack()
  _active = false
  pcall(vim.api.nvim_del_augroup_by_name, augroup)
end

function M.save()
  local current_session = resolve_session(vim.fn.getcwd())
  vim.cmd("mks! " .. e(current_session.file))
end

---@param opts {dir: string?, clean: boolean?, save: boolean?}
function M.load(opts)
  opts = opts or {}
  if opts.save ~= false and should_save() and M.is_active() then
    M.save()
  end
  if opts.clean ~= false then
    Snacks.bufdelete.all()
  end

  local session = resolve_session(opts.dir)
  local session_loaded = false
  vim.fn.chdir(session.dir)
  if vim.fn.filereadable(session.file) ~= 0 then
    vim.cmd("silent! source " .. e(session.file))
    session_loaded = true
  end

  default_callback(session_loaded)
end

---@return string[]
local function glob_session_files()
  local files = vim.fn.glob(save_dir .. "*.vim", true, true)
  table.sort(files, function(a, b)
    return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec
  end)
  return files
end

---@return { session: string, dir: string, branch?: string }[]
function M.list()
  local items = {}
  local have = {} ---@type table<string, boolean>
  for _, session in ipairs(glob_session_files()) do
    if vim.uv.fs_stat(session) then
      local file = session:sub(#save_dir + 1, -5)
      local dir, branch = unpack(vim.split(file, "@@", { plain = true }))
      dir = dir:gsub("%%", "/")
      if jit.os:find("Windows") then
        dir = dir:gsub("^(%w)/", "%1:/")
      end
      if not have[dir] then
        have[dir] = true
        items[#items + 1] = { session = session, dir = dir, branch = branch }
      end
    end
  end
  return items
end

function M.select()
  vim.ui.select(M.list(), {
    prompt = "Select a session: ",
    format_item = function(item)
      return vim.fn.fnamemodify(item.dir, ":p:~")
    end,
  }, function(item)
    if item then
      M.load { dir = item.dir }
    end
  end)
end

--Delete a session
---@param dir? string
---@return nil
function M.delete(dir)
  local session = resolve_session(dir)
  vim.fn.delete(vim.fn.expand(session.file))
end

local function session_finder()
  local items = {}
  for _, session in ipairs(M.list()) do
    items[#items + 1] = {
      text = session.dir,
      dir = session.dir,
      branch = session.branch,
      session = vim.fs.basename(session.dir) or session.dir,
    }
  end
  return items
end

function M.pick()
  Snacks.picker {
    finder = session_finder,
    title = "Sessions",
    layout = { preset = "select", layout = { max_width = 150 } },

    format = function(item)
      return {
        { item.session, "SnacksPickerFile" },
        { " " },
        { item.branch and "(" .. item.branch .. ")" or "", "SnacksPickerGitBranch" },
        { " " },
        { item.dir, "SnacksPickerDir" },
      }
    end,

    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      M.load { dir = item.dir }
    end,

    actions = {
      delete = function(picker)
        local selected = picker:selected { fallback = true }
        for _, item in ipairs(selected) do
          M.delete(item.dir)
        end
        picker:refresh()
      end,
    },

    win = {
      input = {
        keys = {
          ["<c-x>"] = { "delete", mode = { "n", "i" } },
        },
      },
    },
  }
end

return M
