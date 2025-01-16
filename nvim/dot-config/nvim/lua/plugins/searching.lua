local picker_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Snacks Picker" }
local flash_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Flash" }
return {
  {
    "folke/snacks.nvim",
    opts = { picker = { enabled = true, sources = { files = { follow = true } } } },
    -- stylua: ignore
    keys = function(keys)
      return vim.list_extend(
        keys,
        picker_map {
          {"<leader>,",         function()  Snacks.picker.buffers() end,            desc = "Buffer", },
          { "<leader>/",        function()  Snacks.picker.grep() end,               desc = "Grep (Root Dir)" },
          { "<leader>:",        function()  Snacks.picker.command_history() end,    desc = "Command History" },
          { "<leader><space>",  function()  Snacks.picker.files() end,              desc = "Files (Root Dir)" },
          -- find
          { "<leader>fb",       function()  Snacks.picker.buffers() end,            desc = "Buffers" },
          { "<leader>fc",       function()  Snacks.picker.files { cwd = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config/" } end, desc = "Config File" },
          { "<leader>ff",       function()  Snacks.picker.files() end,              desc = "Files (Root Dir)" },
          { "<leader>fg",       function()  Snacks.picker.git_files() end,          desc = "Files (git-files)" },
          { "<leader>fr",       function()  Snacks.picker.recent() end,             desc = "Recent" },
          -- git
          { "<leader>gc",       function()  Snacks.picker.git_log() end,            desc = "Commits" },
          { "<leader>gs",       function()  Snacks.picker.git_status() end,         desc = "Git Status" },
          { "<leader>gH",       function()  Snacks.picker.git_diff() end,           desc = "Git Hunk" },
          -- search
          { '<leader>s"',       function()  Snacks.picker.registers() end,          desc = "Registers" },
          { "<leader>sa",       function()  Snacks.picker.autocmds() end,           desc = "Auto Commands" },
          { "<leader>sb",       function()  Snacks.picker.lines() end,              desc = "Buffer" },
          { "<leader>sB",       function()  Snacks.picker.grep_buffers() end,       desc = "Buffers" },
          { "<leader>sc",       function()  Snacks.picker.command_history() end,    desc = "Command History" },
          { "<leader>sC",       function()  Snacks.picker.commands() end,           desc = "Commands" },
          { "<leader>sd",       function()  Snacks.picker.diagnostics() end,        desc = "Document Diagnostics" },
          { "<leader>sg",       function()  Snacks.picker.grep() end,               desc = "Grep (Root Dir)" },
          { "<leader>sh",       function()  Snacks.picker.help() end,               desc = "Help Pages" },
          { "<leader>sH",       function()  Snacks.picker.highlights() end,         desc = "Highlight Groups" },
          { "<leader>sj",       function()  Snacks.picker.jumps() end,              desc = "Jumplist" },
          { "<leader>sk",       function()  Snacks.picker.keymaps() end,            desc = "Key Maps" },
          { "<leader>sl",       function()  Snacks.picker.loclist() end,            desc = "Location List" },
          { "<leader>sM",       function()  Snacks.picker.man() end,                desc = "Man Pages" },
          { "<leader>sm",       function()  Snacks.picker.marks() end,              desc = "Jump to Mark" },
          { "<leader>sR",       function()  Snacks.picker.resume() end,             desc = "Resume" },
          { "<leader>sq",       function()  Snacks.picker.qflist() end,             desc = "Quickfix List" },
          { "<leader>sw",       function()  Snacks.picker.grep_word() end,          desc = "Word (Root Dir)", mode = { "n", "x" }},
          { "<leader>ss", function()   Snacks.picker.lsp_symbols() end,             desc = "Symbol" },
          { "gd", function()   Snacks.picker.lsp_definitions() end,                 desc = "LSP Definition" },
          { "gr", function()   Snacks.picker.lsp_references() end,                  desc = "LSP References" },
          { "gI", function()   Snacks.picker.lsp_implementations() end,             desc = "LSP Implementations" },
          { "gD", function()   Snacks.picker.lsp_type_definitions() end,            desc = "LSP Type Definitions" },
          { "<leader>qp", function()   Snacks.picker.projects() end,                desc = "Projects" },
        }
      )
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
