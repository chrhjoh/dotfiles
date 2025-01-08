local oil_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Oil" }
return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },
    opts = {
      columns = {
        "icon",
        -- "permissions",
        --'size',
        --'mtime',
      },
      win_options = {},
      view_options = { show_hidden = true },
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
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
          require("trouble").open { mode = "quickfix", refresh = true, new = false }
        end,
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-p>"] = { "actions.preview" },
      },
    },
    keys = function()
      return oil_map {
        {
          "-",
          function()
            require("oil").open()
          end,
          desc = "Open Oil buffer In Parent Directory",
        },
        {
          "<leader>f-",
          function()
            require("oil").open(vim.fn.getcwd())
          end,
          desc = "Open Oil buffer In Root Directory",
        },
      }
    end,
  },
}
