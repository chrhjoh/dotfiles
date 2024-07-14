return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "ObsidianWorkspace", "ObsidianNew" },
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre " .. vim.fn.expand("~") .. "/Documents/vaults/Work/**/*.md",
    "BufReadPre " .. vim.fn.expand("~") .. "/Documents/vaults/Personal/**/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/vaults/Personal/",
        },
        {
          name = "work",
          path = "~/Documents/vaults/Work/"
        },
      },
      -- see below for full list of options 👇
      mappings = {},
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. "-" .. tostring(os.time())
      end,
      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
    })
    vim.keymap.set(
      "n",
      "<leader>of",
      '<cmd>ObsidianFollow<CR>',
      { noremap = false, desc = "[O]bsidian [F]ollow" }
    )
    vim.keymap.set(
      "n",
      "<leader>on",
      "<cmd>ObsidianNew<CR>",
      { noremap = false, desc = "[O]bsidian [N]ew Note" }
    )
    vim.keymap.set(
      "n",
      "<leader>ot",
      "<cmd>ObsidianTemplate<CR>",
      { noremap = false, desc = "[O]bsidian [T]emplate" }
    )
    vim.keymap.set(
      "n",
      "<leader>od",
      '<cmd>require("obsidian").util.toggle_checkbox()<CR>',
      { noremap = false, desc = "[O]bsidian [D]one" }
    )
    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "[O]pen in [O]bsidian App" })
    vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show [O]bsidian[B]acklinks" })
    vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Show [O]bsidian[L]inks" })
    vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", { desc = "Choose [O]bsidian [W]orkspaces" })
    vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "[O]bsidian [Q]uick Switch" })
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "[O]bsidian [S]earch" })
  end,
}
