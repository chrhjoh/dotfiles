local obsidian_key_mapper = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Obsidian" }
return {
  {
    "chrhjoh/obsidian-tools.nvim",
    enabled = os.getenv("OBSIDIAN_HOME") ~= nil,
    lazy = true,
    opts = {
      workspaces = {
        {
          name = "Work",
          directory = os.getenv("OBSIDIAN_HOME") and os.getenv("OBSIDIAN_HOME") .. "/Work/" or "",
        },
        {
          name = "Personal",
          directory = os.getenv("OBSIDIAN_HOME") and os.getenv("OBSIDIAN_HOME") .. "/Personal/" or "",
        },
      },
    },
    --stylua: ignore
    keys = function()
      return obsidian_key_mapper { 
        {"<leader>oo", function() require("obsidian-tools").open_in_obsidian() end, desc = "Open in Obsidian"},
        {"<leader>on", function() require("obsidian-tools").new_from_prompt() end, desc = "New Note"},
        {"<leader>on", function() require("obsidian-tools").new_from_visual() end, desc = "New Note", mode = "v"},
        {"<leader>of", function() require("obsidian-tools").quickswitch() end, desc = "Find Note"},
        {"<leader>ot", function() require("obsidian-tools").apply_template() end, desc = "Apply Template"},
        {"<leader>ow", function() require("obsidian-tools").select_workspace() end, desc = "Select Workspace"},
      }
    end,
  },
}
