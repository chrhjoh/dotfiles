---@class CoreUtils
local M = {}

function M.plugin_dir(plugin)
  local pack = vim.pack.get { plugin }
  assert(#pack == 1, "Must only be one plugin returned")
  return pack[1].path
end

M.lualine = {
  snacks_picker = {
    sections = {
      lualine_a = {
        function()
          return "Snacks Picker: " .. (Snacks.picker.get()[1].title or "")
        end,
      },
    },

    filetypes = { "snacks_picker_input" },
  },
  snacks_notifications = {
    sections = {
      lualine_a = {
        function()
          return "Notifications"
        end,
      },
    },

    filetypes = { "snacks_notif_history" },
  },
}

function M.is_subdir(dir, parent)
  dir = vim.fs.normalize(vim.fn.fnamemodify(dir, ":p"))
  parent = vim.fs.normalize(vim.fn.fnamemodify(parent, ":p"))

  -- A directory is considered a subdirectory of itself
  if dir == parent then
    return true
  end

  local sep = package.config:sub(1, 1)
  return dir:sub(1, #parent + 1) == parent .. sep
end

function M.project_picker(opts)
  opts = opts or {}

  Snacks.picker.projects {
    title = opts.title,
    projects = opts.projects,
    dev = { "~/code", "~/projects", "~/Obsidian/" },
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      require("core").session.load { dir = item.file }
    end,

    filter = {
      filter = function(item)
        if Core.utils.is_subdir(item.file, vim.fn.stdpath("data")) then
          return false
        end
        return true
      end,
    },
    actions = {
      oil = function(picker)
        local selected = picker:selected { fallback = true }
        picker:close()
        require("oil").open(selected[1].file)
      end,
    },
    win = {
      input = {
        keys = {
          ["<C-O>"] = { "oil", mode = { "n", "i" } },
        },
      },
    },
  }
end

function M.toggle_gitsigns_diff(cmd)
  cmd = cmd or "~"
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:find("^gitsigns://") then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  require("gitsigns").diffthis(cmd)
end

return M
