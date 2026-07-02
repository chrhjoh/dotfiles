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

return M
