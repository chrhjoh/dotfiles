vim.pack.add { "https://github.com/folke/which-key.nvim" }
vim.cmd.packadd("nvim.undotree")

Config.load.load_later(function()
  require("which-key").setup {
    preset = "helix",
    icons = { mappings = false },
    delay = function(ctx)
      return ctx.plugin and 0 or 300
    end,
    spec = {
      mode = { "n" },
      {
        {
          "<leader>b",
          group = "buffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>y", group = "yank" },
        { "<leader>f", group = "files" },
        { "<leader>u", group = "toggle" },
        { "<leader>c", group = "code" },
        { "<leader>w", group = "window" },
        { "<leader>t", group = "terminal" },
        { "<leader>s", group = "search" },
        { "<leader>q", group = "session" },
        { "<leader>g", group = "git" },
        { "<leader>a", group = "ai" },
      },
    },
  }

  local map = Config.mapper.map
  local nmap = Config.mapper.get { mode = "n" }
  local imap = Config.mapper.get { mode = "i" }

  -- adhoc QOL mappings --------------------------------------------------------
  map { "<Space>", "<Nop>", mode = { "n", "v" }, silent = true }
  map {
    "<Esc>",
    function()
      vim.cmd("noh")
      vim.cmd("stopinsert")
      return "<Esc>"
    end,
    mode = { "i", "n", "s" },
    expr = true,
    desc = "Escape and Clear hlsearch",
  }
  map { "<C-s>", "<Cmd>w<Cr><Esc>", mode = { "i", "x", "n", "s" }, desc = "Save File", silent = true }
  map { "<", "<gv", desc = "Indent", mode = "v" }
  map { ">", ">gv", desc = "Deindent", mode = "v" }
  nmap { "<Leader>Q", "<Cmd>quit<Cr>", desc = "Quit" }
  nmap { "<Leader>m", "<Cmd>messages<Cr>", desc = "Messages", silent = true }
  nmap { "<Leader>n", Snacks.notifier.show_history, desc = "Notifications" }
  nmap { "<leader>U", require("undotree").open, desc = "Undotree" }
  nmap { "k", "v:count == 0 ? 'gk' : 'k'", desc = "Up", silent = true, expr = true }
  nmap { "j", "v:count == 0 ? 'gj' : 'j'", desc = "Down", silent = true, expr = true }
  nmap { "x", '"_x', desc = "Delete character", noremap = true }

  -- yanking keymaps --------------------------------------------------------
  nmap { "<leader>yP", '<Cmd>let @* = expand("%:p")<Cr>', desc = "Absolute Path" }
  nmap { "<leader>yp", '<Cmd>let @* = expand("%")<Cr>', desc = "Relative Path" }
  nmap { "<leader>yf", '<Cmd>let @* = expand("%:t")<Cr>', desc = "Filename" }

  -- buffer navigation ------------------------------------------------------
  nmap { "<TAB>", ":bn<CR>", desc = "Buffer", silent = true }
  nmap { "<S-TAB>", ":bp<CR>", desc = "Buffer", silent = true }
  nmap { "[b", "<cmd>bprevious<cr>", desc = "Buffer" }
  nmap { "]b", "<cmd>bnext<cr>", desc = "Buffer" }
  nmap { "<Leader>bb", "<cmd>e #<cr>", desc = "Alternative" }
  nmap { "<Leader>`", "<cmd>e #<cr>", desc = "Alternative" }

  -- buffer management ------------------------------------------------------
  nmap { "<Leader>bd", Snacks.bufdelete.delete, desc = "Delete" }
  nmap { "<Leader>bo", Snacks.bufdelete.other, desc = "Delete All Other" }
  nmap { "<Leader>bA", Snacks.bufdelete.all, desc = "Delete all" }

  -- Quickfix management ----------------------------------------------------
  nmap {
    "[q",
    function()
      local ok, err = pcall(vim.cmd.cprev)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,
    desc = "Quickfix Item",
  }
  nmap {
    "]q",
    function()
      local ok, err = pcall(vim.cmd.cnext)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,
    desc = "Quickfix Item",
  }
  local window_is_open = function(variable)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_get_option_value("buftype", { buf = buf }) == variable then
        return true
      end
    end
    return false
  end

  nmap {
    "<Leader>uq",
    function()
      if window_is_open("quickfix") then
        vim.cmd("cclose")
      else
        vim.cmd("copen")
      end
    end,
    desc = "Toggle Quickfix List",
  }

  -- diagnostic movement ----------------------------------------------
  local diagnostic_goto = function(count, severity)
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      vim.diagnostic.jump { severity = severity, count = count }
    end
  end

  nmap { "<Leader>cd", vim.diagnostic.open_float, desc = "Diagnostic Line" }
  nmap { "]d", diagnostic_goto(1), desc = "Diagnostic" }
  nmap { "[d", diagnostic_goto(-1), desc = "Diagnostic" }
  nmap { "]e", diagnostic_goto(1, "ERROR"), desc = "Error" }
  nmap { "[e", diagnostic_goto(-1, "ERROR"), desc = "Error" }
  nmap { "]w", diagnostic_goto(true, "WARN"), desc = "Warning" }
  nmap { "[w", diagnostic_goto(false, "WARN"), desc = "Warning" }

  -- window mappings --------------------------------------------------
  nmap { "<Leader>ww", "<C-W>p", desc = "Other", remap = true }
  nmap { "<Leader>wd", "<C-W>c", desc = "Delete", remap = true }
  nmap { "<Leader>-", "<C-W>s", desc = "New Window Below", remap = true }
  nmap { "<Leader>|", "<C-W>v", desc = "New Window Right", remap = true }
  nmap { "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase Window Height" }
  nmap { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease Window Height" }
  nmap { "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease Window Width" }
  nmap { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase Window Width" }
  nmap { "<C-h>", "<C-W>h", desc = "Move To Left Window" }
  nmap { "<C-j>", "<C-W>j", desc = "Move To Below Window" }
  nmap { "<C-k>", "<C-W>k", desc = "Move To Above Window" }
  nmap { "<C-l>", "<C-W>l", desc = "Move To Right Window" }

  -- insert movement --------------------------------------------------
  imap { "<c-l>", "<right>", desc = "Move Right" }
  imap { "<c-k>", "<up>", desc = "Move Up" }
  imap { "<c-j>", "<down>", desc = "Move Down" }
  imap { "<c-h>", "<left>", desc = "Move Left" }

  -- files management ----------------------------------------------------
  nmap { "<leader>fn", "<cmd>enew<cr>", desc = "New" }
  nmap {
    "<leader>fb",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Buffers",
  }
  nmap {
    "<leader>fB",
    function()
      Snacks.picker.buffers { hidden = true, nofile = true }
    end,
    desc = "Buffers (all)",
  }
  nmap {
    "<leader>fc",
    function()
      Snacks.picker.files { cwd = vim.env.DOTFILES or vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config/" }
    end,
    desc = "Config File",
  }
  nmap {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "Files",
  }
  nmap {
    "<leader>fF",
    function()
      Snacks.picker.files { hidden = true, nofile = true }
    end,
    desc = "Files (all)",
  }
  nmap {
    "<leader>fg",
    function()
      Snacks.picker.git_files()
    end,
    desc = "Files (git-files)",
  }
  nmap {
    "<leader>fr",
    function()
      Snacks.picker.recent()
    end,
    desc = "Recent",
  }

  -- todo comment mappings --------------------------------------

  nmap {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    desc = "ToDo Comment",
  }
  nmap {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    desc = "ToDo Comment",
  }
  nmap {
    "<leader>st",
    function()
      Snacks.picker.todo_comments() ---@diagnostic disable-line: undefined-field
    end,
    desc = "Todo",
  }
  nmap {
    "<leader>sT",
    function()
      Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME" } } ---@diagnostic disable-line: undefined-field
    end,
    desc = "Todo/Fix/Fixme",
  }

  -- conform formatting ------------------------------------------
  nmap {
    "<leader>cf",
    function()
      require("conform").format { async = false, lsp_fallback = true }
    end,
    mode = "n",
    desc = "Format Buffer",
  }

  -- git ---------------------------------------------------------
  local function toggle_diffthis(cmd)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:find("^gitsigns://") then
        vim.api.nvim_win_close(win, true)
        return
      end
    end
    require("gitsigns").diffthis(cmd)
  end

  map {
    "]h",
    function()
      if vim.wo.diff then
        return "]h"
      end
      vim.schedule(function()
        require("gitsigns").nav_hunk("next")
      end)
      return "<Ignore>"
    end,
    expr = true,
    desc = "Hunk",
    mode = { "n", "v" },
  }

  map {
    "[h",
    function()
      if vim.wo.diff then
        return "[h"
      end
      vim.schedule(function()
        require("gitsigns").nav_hunk("prev")
      end)
      return "<Ignore>"
    end,
    expr = true,
    desc = "Hunk",
    mode = { "n", "v" },
  }

  map {
    "<leader>gs",
    function()
      require("gitsigns").stage_hunk { vim.fn.line("."), vim.fn.line("v") }
    end,
    desc = "Stage hunk",
    mode = "v",
  }
  map {
    "<leader>gr",
    function()
      require("gitsigns").reset_hunk { vim.fn.line("."), vim.fn.line("v") }
    end,
    desc = "Reset hunk",
    mode = "v",
  }
  nmap {
    "<leader>gh",
    function()
      require("gitsigns").stage_hunk()
    end,
    desc = "Stage/unstage hunk",
  }
  nmap {
    "<leader>gr",
    function()
      require("gitsigns").reset_hunk()
    end,
    desc = "Reset hunk",
  }
  nmap {
    "<leader>gS",
    function()
      require("gitsigns").stage_buffer()
    end,
    desc = "Stage buffer",
  }
  nmap {
    "<leader>gR",
    function()
      require("gitsigns").reset_buffer()
    end,
    desc = "Reset buffer",
  }
  nmap {
    "<leader>gp",
    function()
      require("gitsigns").preview_hunk()
    end,
    desc = "Preview hunk",
  }
  nmap {
    "<leader>gd",
    function()
      require("gitsigns").preview_hunk_inline()
    end,
    desc = "Diff inline",
  }
  nmap {
    "<leader>gD",
    function()
      toggle_diffthis("~")
    end,
    desc = "Diff last commit",
  }
  nmap {
    "gh",
    function()
      require("gitsigns").select_hunk()
    end,
    desc = "Select git hunk",
    mode = { "o", "x" },
  }
  nmap {
    "<leader>gc",
    function()
      Snacks.picker.git_log()
    end,
    desc = "Commits",
  }
  nmap {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Status",
  }
  nmap {
    "<leader>gH",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Hunks",
  }
  nmap {
    "<leader>gb",
    function()
      Snacks.git.blame_line()
    end,
    desc = "Blame line",
  }
  nmap {
    "<leader>gB",
    function()
      Snacks.gitbrowse()
    end,
    desc = "Browser",
  }

  -- session management -----------------------------------------
  nmap { "<leader>ql", "<CMD>Persisted load<CR>", desc = "Restore CWD" }
  nmap { "<leader>qS", "<CMD>Persisted select<CR>", desc = "Select" }
  nmap { "<leader>qs", "<CMD>Persisted save<CR>", desc = "Save" }
  nmap { "<leader>qL", "<CMD>Persisted load_last<CR>", desc = "Restore Last" }
  nmap { "<leader>qd", "<CMD>Persisted delete_current<CR>", desc = "Delete Current" }
  nmap {
    "<leader>qp",
    function()
      Snacks.picker.projects()
    end,
    desc = "Projects",
  }

  -- oil directory explorer -------------------------------------
  nmap {
    "<leader>e",
    function()
      require("oil").open()
    end,
    desc = "Oil Current",
  }
  nmap {
    "<leader>E",
    function()
      require("oil").open(vim.fs.root(0, { ".git", "pyproject.toml" }))
    end,
    desc = "Oil Root",
  }
  -- flash -----------------------------------------------
  map {
    "s",
    function()
      require("flash").jump()
    end,
    mode = { "n", "x", "o" },
    desc = "Jump",
  }
  map {
    "S",
    function()
      require("flash").treesitter()
    end,
    mode = { "n", "o", "x" },
    desc = "Treesitter",
  }
  map {
    "r",
    function()
      require("flash").remote()
    end,
    mode = "o",
    desc = "Remote",
  }

  -- grug-far -----------------------------------------------

  map {
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
    mode = "n",
    desc = "Search and Replace",
  }
  map {
    "<leader>sr",
    function()
      require("grug-far").open { visualSelectionUsage = "operate-within-range" }
    end,
    mode = "x",
    desc = "Search and Replace",
  }

  -- searching snacks shorhand -----------------------------------------------
  nmap {
    "<leader>,",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Buffer",
  }
  nmap {
    "<leader>/",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep",
  }
  nmap {
    "<leader>:",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  }
  nmap {
    "<leader><space>",
    function()
      Snacks.picker.files()
    end,
    desc = "Files",
  }

  -- searching general ---------------------------------------------------------

  nmap {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = "Registers",
  }
  nmap {
    "<leader>sb",
    function()
      Snacks.picker.lines()
    end,
    desc = "Buffer",
  }
  nmap {
    "<leader>sB",
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = "Buffers",
  }
  nmap {
    "<leader>sc",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  }
  nmap {
    "<leader>sC",
    function()
      Snacks.picker.commands()
    end,
    desc = "Commands",
  }
  nmap {
    "<leader>sD",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "Diagnostics",
  }
  nmap {
    "<leader>sd",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "Buffer Diagnostics",
  }
  nmap {
    "<leader>sg",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep (Root Dir)",
  }
  nmap {
    "<leader>sh",
    function()
      Snacks.picker.help()
    end,
    desc = "Help Pages",
  }
  nmap {
    "<leader>sj",
    function()
      Snacks.picker.jumps()
    end,
    desc = "Jumplist",
  }
  nmap {
    "<leader>sk",
    function()
      Snacks.picker.keymaps()
    end,
    desc = "Key Maps",
  }
  nmap {
    "<leader>sM",
    function()
      Snacks.picker.man()
    end,
    desc = "Man Pages",
  }
  nmap {
    "<leader>sm",
    function()
      Snacks.picker.marks()
    end,
    desc = "Jump to Mark",
  }
  nmap {
    "<leader>sR",
    function()
      Snacks.picker.resume()
    end,
    desc = "Resume",
  }
  nmap {
    "<leader>sq",
    function()
      Snacks.picker.qflist()
    end,
    desc = "Quickfix List",
  }
  nmap {
    "<leader>sw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "Word (Root Dir)",
    mode = { "n", "x" },
  }
  nmap {
    "<leader>ss",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "Symbols",
  }
  nmap {
    "<leader>sS",
    function()
      Snacks.picker.lsp_symbols { workspace = true }
    end,
    desc = "Workspace Symbols",
  }
  nmap {
    "<leader>su",
    function()
      Snacks.picker.undo()
    end,
    desc = "Undotree",
  }
  -- searching lsp -------------------------------------------------------------
  nmap {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "LSP Definition",
  }
  nmap {
    "gr",
    function()
      Snacks.picker.lsp_references()
    end,
    desc = "LSP References",
    nowait = true,
  }
  nmap {
    "gI",
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = "LSP Implementations",
  }
  nmap {
    "gD",
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = "LSP Type Definitions",
  }

  -- terminal management ------------------------------------------------
  nmap {
    "<c-\\>",
    function()
      require("toggleterm").toggle(vim.v.count)
    end,
    desc = "Toggle",
  }
  nmap {
    "<leader>tx",
    function()
      require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count1 })
    end,
    desc = "Send Current Line",
  }
  map {
    "<leader>tx",
    function()
      require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count1 })
    end,
    desc = "Send Selected Lines",
    mode = "v",
  }
  map {
    "<leader>tX",
    function()
      require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count1 })
    end,
    desc = "Send Selection",
    mode = "v",
  }
  nmap {
    "<leader>t|",
    function()
      require("toggleterm").toggle(vim.v.count1, 60, nil, "vertical")
    end,
    desc = "Vertical",
  }
  nmap {
    "<leader>t-",
    function()
      require("toggleterm").toggle(vim.v.count1, 18, nil, "horizontal")
    end,
    desc = "Horizontal",
  }
  nmap {
    "<leader>tf",
    function()
      require("toggleterm").toggle(vim.v.count1, nil, nil, "float")
    end,
    desc = "Floating",
  }

  local function toggle_terminal(cmd, id)
    local terminal = require("toggleterm.terminal").Terminal
    return terminal:new {
      cmd = cmd,
      hidden = true,
      direction = "float",
      close_on_exit = true,
      id = id,
    }
  end

  if vim.fn.executable("lazygit") == 1 then
    local lazygit = nil
    local lazygit_log = nil
    local lazygit_file = nil
    nmap {
      "<leader>gg",
      function()
        lazygit = lazygit or toggle_terminal("lazygit", 100)
        lazygit:toggle()
      end,
      desc = "Lazygit",
    }
    nmap {
      "<leader>gl",
      function()
        lazygit_log = lazygit_log or toggle_terminal("lazygit log", 101)
        lazygit_log:toggle()
      end,
      desc = "Lazygit Log",
    }
    nmap {
      "<leader>gf",
      function()
        local file = vim.trim(vim.api.nvim_buf_get_name(0))
        lazygit_file = lazygit_file or toggle_terminal("lazygit log -f " .. file, 102)
        lazygit_file:toggle()
      end,
      desc = "Lazygit Current File History",
    }
  end
  -- snacks -----------------------------------------------------------

  nmap { "<leader>H", Snacks.dashboard.open, desc = "Dashboard" }
  nmap { "leadercR", Snacks.rename.rename_file, desc = "Rename File" }
  map {
    "[[",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    mode = { "n", "t" },
    desc = "Reference",
  }
  map {
    "]]",
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    mode = { "n", "t" },
    desc = "Reference",
  }

  -- which-key ------------------------------------------------------
  nmap {
    "<leader>?",
    function()
      require("which-key").show { global = false }
    end,
    desc = "Local mappings",
  }
  -- ai ---------------------------------------------------------------
  map {
    "<c-.>",
    function()
      require("sidekick.cli").focus()
    end,
    desc = "Sidekick Focus",
    mode = { "n", "t", "i", "x" },
  }
  nmap {
    "<leader>aa",
    function()
      require("sidekick.cli").toggle()
    end,
    desc = "Sidekick Toggle CLI",
  }
  nmap {
    "<leader>as",
    function()
      require("sidekick.cli").select()
    end,
    -- Or to select only installed tools:
    -- require("sidekick.cli").select({ filter = { installed = true } })
    desc = "Select CLI",
  }
  nmap {
    "<leader>ad",
    function()
      require("sidekick.cli").close()
    end,
    desc = "Detach a CLI Session",
  }
  nmap {
    "<leader>at",
    function()
      require("sidekick.cli").send { msg = "{this}" }
    end,
    mode = { "x", "n" },
    desc = "Send This",
  }
  nmap {
    "<leader>af",
    function()
      require("sidekick.cli").send { msg = "{file}" }
    end,
    desc = "Send File",
  }
  nmap {
    "<leader>av",
    function()
      require("sidekick.cli").send { msg = "{selection}" }
    end,
    mode = { "x" },
    desc = "Send Visual Selection",
  }
  nmap {
    "<leader>ap",
    function()
      require("sidekick.cli").prompt()
    end,
    mode = { "n", "x" },
    desc = "Sidekick Select Prompt",
  }

  -- treesitter ----------------------------------------------------------
  nmap {
    "<leader>]",
    function()
      require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end,
    desc = "Swap Next Parameter",
  }
  nmap {
    "<leader>[",
    function()
      require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
    end,
    desc = "Swap Previous Parameter",
  }
  local moves = {
    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
  }
  for method, keymaps in pairs(moves) do
    for key, query in pairs(keymaps) do
      local desc = query:gsub("@", ""):gsub("%..*", "")
      desc = desc:sub(1, 1):upper() .. desc:sub(2)
      desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
      desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
      map {
        key,
        function()
          -- don't use treesitter if in diff mode and the key is one of the c/C keys
          if vim.wo.diff and key:find("[cC]") then
            return vim.cmd("normal! " .. key)
          end
          require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
        end,
        desc = desc,
        mode = { "n", "x", "o" },
        silent = true,
      }
    end
  end
end)
