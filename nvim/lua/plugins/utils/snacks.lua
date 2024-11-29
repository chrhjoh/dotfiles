return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { pane = 1, section = "header" },
        { pane = 1, section = "keys", gap = 1, padding = 1 },
        { pane = 2, padding = 8 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    }
  },
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end,          desc = "Delete Buffer" },
    { "<leader>gb", function() Snacks.git.blame_line() end,     desc = "Git Blame Line" },
    { "<leader>gB", function() Snacks.gitbrowse() end,          desc = "Git Browse" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.diagnostics({ bufnr = 0 }):map("<leader>ud")
        Snacks.toggle({
          name = "Format (Buffer)",
          get = function() return vim.b[0].autoformat == nil or vim.b[0].autoformat end,
          set = function(state) vim.b[0].autoformat = not state end
        }
        ):map("<leader>uf")
        Snacks.toggle({
          name = "Format (Global)",
          get = function() return vim.g.autoformat == nil or vim.g.autoformat end,
          set = function(state) vim.g.autoformat = not state end
        }
        ):map("<leader>uf")
        Snacks.toggle({
          name = "Zen Mode",
          get = function() return require("zen-mode.view").is_open() end,
          set = function(_)
            require("zen-mode").toggle({})
          end
        }):map("<leader>uz")
        Snacks.toggle({
          name = "Git Blame Line",
          get = function() return require("gitsigns.config").config.current_line_blame end,
          set = function(_) require("gitsigns").toggle_current_line_blame() end
        }):map("<leader>ub")
        Snacks.toggle({
          name = "Git Deleted",
          get = function() return require("gitsigns.config").config.show_deleted end,
          set = function(_) require("gitsigns").toggle_deleted() end
        }):map("<leader>uD")
        Snacks.toggle({
          name = "CSV View",
          get = function() return require('csvview').is_enabled(vim.api.nvim_get_current_buf()) end,
          set = function(_) require('csvview').toggle() end
        }):map("<leader>uC")
      end,
    })
  end,
}
