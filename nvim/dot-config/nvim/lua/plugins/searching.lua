local fzf_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Fzf" }
local flash_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Flash" }
return {
  {
    "ibhagwan/fzf-lua",
    opts = function()
      local fzf_actions = require("fzf-lua.actions")
      local trouble_fzf_actions = require("trouble.sources.fzf").actions
      return {
        fzf_colors = true,
        files = {
          actions = {
            ["alt-i"] = fzf_actions.toggle_ignore,
            ["alt-."] = fzf_actions.toggle_hidden,
            ["ctrl-t"] = trouble_fzf_actions.open,
          },
        },
        grep = {
          rg_glob = true,
          actions = {
            ["alt-i"] = fzf_actions.toggle_ignore,
            ["alt-."] = fzf_actions.toggle_hidden,
            ["ctrl-t"] = trouble_fzf_actions.open,
          },
        },
        helptags = { actions = { ["enter"] = fzf_actions.help_vert } },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
        },
        keymap = {
          builtin = {
            true,
            ["ctrl-f"] = "preview-page-down",
            ["ctrl-b"] = "preview-page-up",
            ["<Esc>"] = "abort",
          },
          fzf = {
            true,
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-u"] = "half-page-up",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-x"] = "jump",
          },
        },
      }
    end,
    keys = function()
      return fzf_map {
        { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
        { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
        {
          "<leader>,",
          function()
            require("fzf-lua").buffers { sort_mru = true, sort_lastused = true }
          end,
          desc = "Buffer",
        },
        {
          "<leader>/",
          function()
            require("fzf-lua").live_grep {}
          end,
          desc = "Grep (Root Dir)",
        },
        {
          "<leader>:",
          function()
            require("fzf-lua").command_history {}
          end,
          desc = "Command History",
        },
        {
          "<leader><space>",
          function()
            require("fzf-lua").files {}
          end,
          desc = "Files (Root Dir)",
        },
        -- find
        {
          "<leader>fb",
          function()
            require("fzf-lua").buffers { sort_mru = true, sort_lastused = true }
          end,
          desc = "Buffers",
        },
        {
          "<leader>fc",
          function()
            require("fzf-lua").files { cwd = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config/" }
          end,
          desc = "Config File",
        },
        {
          "<leader>ff",
          function()
            require("fzf-lua").files {}
          end,
          desc = "Files (Root Dir)",
        },
        {
          "<leader>fF",
          function()
            require("fzf-lua").files { root = false }
          end,
          desc = "Files (cwd)",
        },
        {
          "<leader>fg",
          function()
            require("fzf-lua").git_files {}
          end,
          desc = "Files (git-files)",
        },
        {
          "<leader>fr",
          function()
            require("fzf-lua").oldfiles {}
          end,
          desc = "Recent",
        },
        {
          "<leader>fR",
          function()
            require("fzf-lua").oldfiles { cwd = vim.uv.cwd() }
          end,
          desc = "Recent (cwd)",
        },
        -- git
        {
          "<leader>gc",
          function()
            require("fzf-lua").git_commits {}
          end,
          desc = "Commits",
        },
        {
          "<leader>gs",
          function()
            require("fzf-lua").git_status {}
          end,
          desc = "Git Status",
        },
        -- search
        {
          '<leader>s"',
          function()
            require("fzf-lua").registers {}
          end,
          desc = "Registers",
        },
        {
          "<leader>sa",
          function()
            require("fzf-lua").autocmds {}
          end,
          desc = "Auto Commands",
        },
        {
          "<leader>sb",
          function()
            require("fzf-lua").grep_curbuf {}
          end,
          desc = "Buffer",
        },
        {
          "<leader>sc",
          function()
            require("fzf-lua").command_history {}
          end,
          desc = "Command History",
        },
        {
          "<leader>sC",
          function()
            require("fzf-lua").commands {}
          end,
          desc = "Commands",
        },
        {
          "<leader>sd",
          function()
            require("fzf-lua").diagnostics_document {}
          end,
          desc = "Document Diagnostics",
        },
        {
          "<leader>sD",
          function()
            require("fzf-lua").diagnostics_workspace {}
          end,
          desc = "Workspace Diagnostics",
        },
        {
          "<leader>sg",
          function()
            require("fzf-lua").live_grep {}
          end,
          desc = "Grep (Root Dir)",
        },
        {
          "<leader>sG",
          function()
            require("fzf-lua").live_grep { root = false }
          end,
          desc = "Grep (cwd)",
        },
        {
          "<leader>sh",
          function()
            require("fzf-lua").helptags {}
          end,
          desc = "Help Pages",
        },
        {
          "<leader>sH",
          function()
            require("fzf-lua").highlights {}
          end,
          desc = "Highlight Groups",
        },
        {
          "<leader>sj",
          function()
            require("fzf-lua").jumps {}
          end,
          desc = "Jumplist",
        },
        {
          "<leader>sk",
          function()
            require("fzf-lua").keymaps {}
          end,
          desc = "Key Maps",
        },
        {
          "<leader>sl",
          function()
            require("fzf-lua").loclist {}
          end,
          desc = "Location List",
        },
        {
          "<leader>sM",
          function()
            require("fzf-lua").man_pages {}
          end,
          desc = "Man Pages",
        },
        {
          "<leader>sm",
          function()
            require("fzf-lua").marks {}
          end,
          desc = "Jump to Mark",
        },
        {
          "<leader>sR",
          function()
            require("fzf-lua").resume {}
          end,
          desc = "Resume",
        },
        {
          "<leader>sq",
          function()
            require("fzf-lua").quickfix {}
          end,
          desc = "Quickfix List",
        },
        {
          "<leader>sw",
          function()
            require("fzf-lua").grep_cword {}
          end,
          desc = "Word (Root Dir)",
        },
        {
          "<leader>sW",
          function()
            require("fzf-lua").grep_cword { root = false }
          end,
          desc = "Word (cwd)",
        },
        {
          "<leader>sw",
          function()
            require("fzf-lua").grep_visual {}
          end,
          mode = "v",
          desc = "Selection (Root Dir)",
        },
        {
          "<leader>sW",
          function()
            require("fzf-lua").grep_visual { root = false }
          end,
          mode = "v",
          desc = "Selection (Cwd)",
        },
        {
          "<leader>ss",
          function()
            require("fzf-lua").lsp_document_symbols {}
          end,
          desc = "Symbol",
        },
        {
          "<leader>sS",
          function()
            require("fzf-lua").lsp_live_workspace_symbols {}
          end,
          desc = "Symbol (Workspace)",
        },
        {
          "gd",
          function()
            require("fzf-lua").lsp_definitions { jump_to_single_result = true, ignore_current_line = true }
          end,
          desc = "LSP Definition",
        },

        {
          "gr",
          function()
            require("fzf-lua").lsp_references { jump_to_single_result = true, ignore_current_line = true }
          end,
          desc = "LSP References",
        },
        {
          "gI",
          function()
            require("fzf-lua").lsp_implementations { jump_to_single_result = true, ignore_current_line = true }
          end,
          desc = "LSP Implementations",
        },
        {
          "gD",
          function()
            require("fzf-lua").lsp_typesdefs { jump_to_single_result = true, ignore_current_line = true }
          end,
          desc = "LSP Type Definitions",
        },
      }
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
    -- stylua: ignore
    keys = function() return flash_map {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Jump" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash" },
    }end,
  },
}
