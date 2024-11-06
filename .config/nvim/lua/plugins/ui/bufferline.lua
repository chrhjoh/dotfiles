local function find_index(name, list)
  local result = ""
  name = require("plenary.path"):new(name):make_relative(vim.loop.cwd())
  for i, item in ipairs(list) do
    if string.match(name, item.value) then
      result = result .. " 󰛢" .. i
    end
  end
  return result
end
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = { 'nvim-tree/nvim-web-devicons', },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local bufferline = require("bufferline")
    local harpoon = require("harpoon")
    bufferline.setup {
      options = {
        style_preset = bufferline.style_preset.minimal,
        always_show_bufferline = false,
        color_icons = false,
        name_formatter = function(buf)
          local harpoon_list = harpoon:list().items
          local number = find_index(buf.path, harpoon_list)
          return number .. " " .. buf.name
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true, -- use a "true" to enable the default, or set your own character

          }
        }
      }
    }
  end
}
