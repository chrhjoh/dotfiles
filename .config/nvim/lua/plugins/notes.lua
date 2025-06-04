local obsidian_key_mapper = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Obsidian" }
local function desc_w_prefix(desc)
  return "Obsidian: " .. desc
end
local function prompted_command(prompt_title, cmd)
  vim.ui.input({ prompt = prompt_title }, function(input)
    if input == nil then
      return
    end
    vim.cmd(cmd .. input)
  end)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    enabled = os.getenv("OBSIDIAN_HOME") ~= nil,
    ft = "markdown",
    version = "*",
    cmd = {
      "Obsidian",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "Work",
          path = os.getenv("OBSIDIAN_HOME") and os.getenv("OBSIDIAN_HOME") .. "/Work" or nil,
        },
        {
          name = "Personal",
          path = os.getenv("OBSIDIAN_HOME") and os.getenv("OBSIDIAN_HOME") .. "/Personal" or nil,
        },
      },
      notes_subdir = nil,
      daily_notes = {
        folder = "_timestamps/",
        date_format = "%Y/%Y-%m-%d-%A",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },
      completion = { min_chars = 2 },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = desc_w_prefix("Follow Link") },
        },
      },
      new_notes_location = "current_dir",
      open = {
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
        end,
      },

      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. "-" .. tostring(os.date("%Y%m%d"))
      end,
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        if out.created == nil then
          out.created = tostring(os.date("%Y-%m-%d"))
        end

        return out
      end,
      preferred_link_style = "wiki",
      wiki_linc_func = "prepend_note_id",
      follow_url_func = function(url)
        vim.ui.open(url)
      end,
      follow_img_func = function(img)
        vim.ui.open(img)
      end,
      templates = {
        folder = "_templates/neovim",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      ui = { enable = false },
      attachments = { img_folder = "assets" },
    },
    -- stylua: ignore
     keys = function()
       return obsidian_key_mapper {
         {"<leader>oo", "<cmd>Obsidian open<cr>",                         desc="Open File in App"},
         {"<leader>on", "<cmd>Obsidian new<cr>",                          desc="Create new note"},
         {"<leader>oT", "<cmd>Obsidian new_from_template<cr>",            desc="Create new note from template"},
         {"<leader>of", "<cmd>Obsidian quick_switch<cr>",                 desc="Find Note"},
         {"<leader>og", "<cmd>Obsidian follow_link<cr>",                  desc="Open Reference"},
         {"<leader>o|", "<cmd>Obsidian follow_link vsplit<cr>",           desc="Open Reference in vsplit"},
         {"<leader>o-", "<cmd>Obsidian follow_link hsplit<cr>",           desc="Open Reference in hsplit"},
         {"<leader>ob", "<cmd>Obsidian backlinks<cr>",                    desc="Find Backlinks"},
         {"<leader>oF", "<cmd>Obsidian tags<cr>",                         desc="Find Note by tag"},
         {"<leader>ot", "<cmd>Obsidian today " .. vim.v.count .. "<cr>",  desc="Open Daily Note Relative To Today"},
         {"<leader>os", "<cmd>Obsidian search<cr>",                       desc="Seach Notes"},
         {"<leader>ol", "<cmd>Obsidian links<cr>",                        desc="Find Link in buffer"},
         {"<leader>ow", "<cmd>Obsidian workspace<cr>",                    desc="Change Workspace"},
         {"<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>",              desc="Toggle Checkbox"},
         {"<leader>op", function() prompted_command("Image Name","Obsidian paste_img") end,     desc="Paste Image"},
         {"<leader>oL", function() prompted_command("ID/path/alias","Obsidian link") end,       desc="Link to current note",  mode="v"},
         {"<leader>ol", function() prompted_command("Optional Title","Obsidian link_new") end,  desc="Create new note from selection and link", mode="v"},
         {"<leader>oe", function() prompted_command("Optional Title","Obsidian extract_note") end, desc="Extract to new note and link", mode="v"},
       }
     end,
  },
}
