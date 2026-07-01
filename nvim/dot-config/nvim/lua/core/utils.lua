---@class CoreUtils
local M = {}

function M.plugin_dir(plugin)
  local pack = vim.pack.get { plugin }
  assert(#pack == 1, "Must only be one plugin returned")
  return pack[1].path
end

--mimics the select handling from persisted.select()
local function handle_session_select(session)
  local p = require("persisted")
  p.fire("SelectPre")
  vim.fn.chdir(session)
  p.load()
  p.fire("SelectPost")
end

function M.project_action(dir)
  local session_loaded = false
  vim.api.nvim_create_autocmd("SessionLoadPost", {
    once = true,
    callback = function()
      session_loaded = true
    end,
  })
  handle_session_select(dir)
  vim.defer_fn(function()
    if not session_loaded then
      Snacks.picker.files()
    end
  end, 100)
end

function M.find_sessions()
  local items = {}
  local found = {}
  local sessions = require("persisted").list()

  for _, session in ipairs(sessions) do
    if vim.uv.fs_stat(session) then
      local file = session:sub(#require("persisted.config").save_dir + 1, -5)
      local dir, branch = unpack(vim.split(file, "@@", { plain = true }))

      dir = dir:gsub("%%", "/")
      if jit.os:find("Windows") then
        dir = dir:gsub("^(%w)/", "%1:/")
      end

      local key = dir .. (branch or "")
      if not found[key] then
        found[key] = true
        items[#items + 1] = {
          path = session,
          text = dir,
          dir = dir,
          branch = branch,
          session = vim.fs.basename(dir) or dir,
        }
        Snacks.debug(items)
      end
    end
  end
  return items
end

function M.pick_session()
  Snacks.picker {
    finder = M.find_sessions,
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
      handle_session_select(item.dir)
    end,

    actions = {
      delete = function(picker)
        local selected = picker:selected { fallback = true }
        for _, item in ipairs(selected) do
          require("persisted").delete_current { path = item.path }
        end
        vim.defer_fn(function()
          picker:refresh()
        end, 100)
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
