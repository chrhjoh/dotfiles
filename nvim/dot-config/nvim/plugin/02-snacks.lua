vim.pack.add { { src = "https://github.com/folke/snacks.nvim", version = "main" } }
require("snacks").setup {
  quickfile = { enabled = true },
  input = { enabled = true },
  scope = { enabled = true },
  notifier = { enabled = true },
  words = { enabled = true },
  bigfile = { enabled = true },
  scroll = { enabled = true },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
        },
      },
    },
    actions = {
      ---@param p snacks.Picker
      toggle_cwd = function(p)
        local root = vim.fs.root(p.input.filter.current_buf, { ".git" })
        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
        local current = p:cwd()
        p:set_cwd(current == root and cwd or root)
        p:find()
      end,
    },
  },
  image = {
    enabled = true,
    math = {
      latex = {
        font_size = "small",
      },
    },
  },
  statuscolumn = { enabled = true },
  indent = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = "󰏖 ", key = "p", desc = "Plugins", action = ":lua vim.pack.update(nil, { offline = true })" },
        { icon = " ", key = "s", desc = "Restore Session", action = ":Persisted load" },
        { icon = "󰆓 ", key = "S", desc = "Select Session", action = ":Persisted select" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 2 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
    },
  },
}

vim._print = function(_, ...)
  Snacks.debug.inspect(...)
end

local function lazy_setup()
  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  Snacks.toggle.line_number():map("<leader>ul")
  Snacks.toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
    :map("<leader>uc")

  -- Toogle various ui elements
  Snacks.toggle.treesitter():map("<leader>uT")
  Snacks.toggle.inlay_hints():map("<leader>uh")
  Snacks.toggle.diagnostics({ bufnr = 0 }):map("<leader>uD")
  Snacks.toggle.zen():map("<leader>uZ")
  Snacks.toggle.dim():map("<leader>uz")
  Snacks.toggle.indent():map("<leader>ui")

  Snacks.toggle({
    name = "Buffer Diagnostics",
    get = function()
      return vim.diagnostic.is_enabled { bufnr = 0 }
    end,
    set = function(_)
      vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = 0 }, { bufnr = 0 })
    end,
  }):map("<leader>ud")

  Snacks.toggle({
    name = "Buffer Format",
    get = function()
      return not vim.b[0].disable_autoformat
    end,
    set = function(_)
      vim.b[0].disable_autoformat = not vim.b[0].disable_autoformat
    end,
  }):map("<leader>uf")

  Snacks.toggle({
    name = "Global Format",
    get = function()
      return not vim.g.disable_autoformat
    end,
    set = function(_)
      vim.g.disable_autoformat = not vim.g.disable_autoformat
    end,
  }):map("<leader>uF")

  Snacks.toggle({
    name = "Completion Menu",
    get = function()
      return vim.b.completion ~= false
    end,
    set = function(state)
      vim.b.completion = state
    end,
  }):map("<leader>um")

  Snacks.toggle({
    name = "Git Blame Line",
    get = function()
      return require("gitsigns.config").config.current_line_blame
    end,
    set = function(_)
      require("gitsigns").toggle_current_line_blame()
    end,
  }):map("<leader>ub")

  Snacks.toggle({
    name = "Git Deleted",
    get = function()
      return require("gitsigns.config").config.show_deleted
    end,
    set = function(_)
      require("gitsigns").preview_hunk_inline()
    end,
  }):map("<leader>ug")

  Snacks.toggle({
    name = "Hardtime",
    get = function()
      return vim.g.hardtime_enabled
    end,
    set = function()
      vim.g.hardtime_enabled = not vim.g.hardtime_enabled
      vim.cmd("Hardtime toggle")
    end,
  }):map("<leader>uH")
  Snacks.toggle({
    name = "Sidekick NES",
    get = function()
      return vim.g.sidekick_nes
    end,
    set = function()
      vim.g.sidekick_nes = not vim.g.sidekick_nes
      vim.cmd("Sidekick nes toggle")
    end,
  }):map("<leader>ua")
end

Config.load.load_lazily(lazy_setup)
