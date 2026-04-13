vim.pack.add {
  { src = "https://github.com/tpope/vim-unimpaired", version = "master" },
  { src = "https://github.com/tpope/vim-sleuth", version = "master" },
  { src = "https://github.com/tpope/vim-surround", version = "master" },
  { src = "https://github.com/stevearc/oil.nvim", version = "master" },
  { src = "https://github.com/m4xshen/hardtime.nvim", version = "main" },
  { src = "https://github.com/MagicDuck/grug-far.nvim", version = "main" },
  { src = "https://github.com/folke/flash.nvim", version = "main" },
  { src = "https://github.com/folke/lazydev.nvim", version = "main" },
}

Config.load.load_lazily(function()
  require("hardtime").setup { enabled = false }
  require("flash").setup { modes = {
    char = {
      jump_labels = true,
    },
  } }
end)

Config.load.load_on_ft(function()
  require("lazydev").setup {
    libraries = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = Config.utils.plugin_dir("snacks.nvim") }, --TODO: doesnt work
    },
  }
end, "lua")

require("oil").setup {
  columns = {
    "icon",
  },
  win_options = {},
  view_options = { show_hidden = true },
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 3000,
    autosave_changes = "unmodified",
  },
  preview_win = {
    preview_method = "load",
    disable_preview = function(filename)
      return filename == "../"
    end,
  },
  keymaps = {
    ["<C-s>"] = false,
    ["<C-l>"] = false,
    ["<C-h>"] = false,
    ["q"] = { "actions.close", mode = "n" },
    ["<Tab>"] = function()
      require("oil.actions").send_to_qflist.callback()
    end,
    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
    ["<C-p>"] = { "actions.preview" },

    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns { "icon", "permissions", "size", "mtime" }
        else
          require("oil").set_columns { "icon" }
        end
      end,
    },
    ["<leader>sg"] = {
      function()
        Snacks.picker.grep {
          cwd = require("oil").get_current_dir(),
        }
      end,
      mode = "n",
      nowait = true,
      desc = "Grep files in Oil directory",
    },
    ["<leader>ff"] = {
      function()
        Snacks.picker.files {
          cwd = require("oil").get_current_dir(),
        }
      end,
      mode = "n",
      nowait = true,
      desc = "Find files in the Oil directory",
    },
  },
}
