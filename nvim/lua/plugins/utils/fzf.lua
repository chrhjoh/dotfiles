return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = function(_)
      local actions = require("fzf-lua.actions")
      require("fzf-lua").setup({
        fzf_colors = true,
        files = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          rg_glob = true,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
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
          files = {
            true,
            ["ctrl-t"] = require("trouble.sources.fzf").actions.open

          }
        },
      }
      )
    end,
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      {
        "<leader>,",
        "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>/",       function() require("fzf-lua").live_grep() end,                      desc = "Grep (Root Dir)" },
      { "<leader>:",       "<cmd>FzfLua command_history<cr>",                                  desc = "Command History" },
      { "<leader><space>", function() require("fzf-lua").files() end,                          desc = "Find Files (Root Dir)" },
      -- find
      { "<leader>fb",      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",         desc = "Buffers" },
      { "<leader>fc",      function() require("fzf-lua").files({ cwd = "~/.config/" }) end,    desc = "Find Config File" },
      { "<leader>ff",      function() require("fzf-lua").files() end,                          desc = "Find Files (Root Dir)" },
      { "<leader>fF",      function() require("fzf-lua").files({ root = false }) end,          desc = "Find Files (cwd)" },
      { "<leader>fg",      "<cmd>FzfLua git_files<cr>",                                        desc = "Find Files (git-files)" },
      { "<leader>fr",      "<cmd>FzfLua oldfiles<cr>",                                         desc = "Recent" },
      { "<leader>fR",      function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() }) end, desc = "Recent (cwd)" },
      -- git
      { "<leader>gc",      "<cmd>FzfLua git_commits<CR>",                                      desc = "Commits" },
      { "<leader>gs",      "<cmd>FzfLua git_status<CR>",                                       desc = "Status" },
      -- search
      { '<leader>s"',      "<cmd>FzfLua registers<cr>",                                        desc = "Registers" },
      { "<leader>sa",      "<cmd>FzfLua autocmds<cr>",                                         desc = "Auto Commands" },
      { "<leader>sb",      "<cmd>FzfLua grep_curbuf<cr>",                                      desc = "Buffer" },
      { "<leader>sc",      "<cmd>FzfLua command_history<cr>",                                  desc = "Command History" },
      { "<leader>sC",      "<cmd>FzfLua commands<cr>",                                         desc = "Commands" },
      { "<leader>sd",      "<cmd>FzfLua diagnostics_document<cr>",                             desc = "Document Diagnostics" },
      { "<leader>sD",      "<cmd>FzfLua diagnostics_workspace<cr>",                            desc = "Workspace Diagnostics" },
      { "<leader>sg",      function() require("fzf-lua").live_grep() end,                      desc = "Grep (Root Dir)" },
      { "<leader>sG",      function() require("fzf-lua").live_grep({ root = false }) end,      desc = "Grep (cwd)" },
      { "<leader>sh",      "<cmd>FzfLua help_tags<cr>",                                        desc = "Help Pages" },
      { "<leader>sH",      "<cmd>FzfLua highlights<cr>",                                       desc = "Search Highlight Groups" },
      { "<leader>sj",      "<cmd>FzfLua jumps<cr>",                                            desc = "Jumplist" },
      { "<leader>sk",      "<cmd>FzfLua keymaps<cr>",                                          desc = "Key Maps" },
      { "<leader>sl",      "<cmd>FzfLua loclist<cr>",                                          desc = "Location List" },
      { "<leader>sM",      "<cmd>FzfLua man_pages<cr>",                                        desc = "Man Pages" },
      { "<leader>sm",      "<cmd>FzfLua marks<cr>",                                            desc = "Jump to Mark" },
      { "<leader>sR",      "<cmd>FzfLua resume<cr>",                                           desc = "Resume" },
      { "<leader>sq",      "<cmd>FzfLua quickfix<cr>",                                         desc = "Quickfix List" },
      { "<leader>sw",      function() require("fzf-lua").grep_cword() end,                     desc = "Word (Root Dir)" },
      { "<leader>sW",      function() require("fzf-lua").grep_cword({ root = false }) end,     desc = "Word (cwd)" },
      { "<leader>sw",      function() require("fzf-lua").grep_visual() end,                    mode = "v",                       desc = "Selection (Root Dir)" },
      { "<leader>sW",      function() require("fzf-lua").grep_visual({ root = false }) end,    mode = "v",                       desc = "Selection (cwd)" },
      { "<leader>sT",      function() require("fzf-lua").colorschemes() end,                   desc = "Colorscheme with Preview" },
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols({
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
  } }
