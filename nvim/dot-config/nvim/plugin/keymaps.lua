vim.pack.add { "https://github.com/folke/which-key.nvim" }
vim.cmd.packadd("nvim.undotree")

Core.loader.load_later(function()
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
        { "<leader>f", group = "find" },
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

  local map = Core.mapper.map
  local nmap = Core.mapper.get { mode = "n" }
  local imap = Core.mapper.get { mode = "i" }

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
  nmap {
    "<leader>ys",
    function()
      Snacks.picker.yanky() ---@diagnostic disable-line: undefined-field
    end,
    desc = "Search",
  }

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
    "<Leader>ul",
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
  nmap {
    "]d",
    function()
      diagnostic_goto(1)
    end,
    desc = "Diagnostic",
  }
  nmap {
    "[d",
    function()
      diagnostic_goto(-1)
    end,
    desc = "Diagnostic",
  }
  nmap {
    "]e",
    function()
      diagnostic_goto(1, "ERROR")
    end,
    desc = "Error",
  }
  nmap {
    "[e",
    function()
      diagnostic_goto(-1, "ERROR")
    end,
    desc = "Error",
  }
  nmap {
    "]w",
    function()
      diagnostic_goto(true, "WARN")
    end,
    desc = "Warning",
  }
  nmap {
    "[w",
    function()
      diagnostic_goto(false, "WARN")
    end,
    desc = "Warning",
  }

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

  -- find -------------------------------------------------------------
  nmap { "<leader>fb", Snacks.picker.buffers, desc = "Buffers" }
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
  nmap { "<leader>ff", Snacks.picker.files, desc = "Files" }
  nmap {
    "<leader>fF",
    function()
      Snacks.picker.files { hidden = true, nofile = true }
    end,
    desc = "Files (all)",
  }
  nmap { "<leader>fg", Snacks.picker.git_files, desc = "Files (git-files)" }
  nmap { "<leader>fr", Snacks.picker.recent, desc = "Recent" }

  -- todo comment mappings --------------------------------------

  nmap { "]t", require("todo-comments").jump_next, desc = "ToDo Comment" }
  nmap { "[t", require("todo-comments").jump_prev, desc = "ToDo Comment" }
  nmap { "<leader>st", Snacks.picker.todo_comments, desc = "Todo" } ---@diagnostic disable-line: undefined-field
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
  nmap { "<leader>gh", require("gitsigns").stage_hunk, desc = "Stage/unstage hunk" }
  nmap { "<leader>gr", require("gitsigns").reset_hunk, desc = "Reset hunk" }
  nmap { "<leader>gS", require("gitsigns").stage_buffer, desc = "Stage buffer" }
  nmap { "<leader>gR", require("gitsigns").reset_buffer, desc = "Reset buffer" }
  nmap { "<leader>gp", require("gitsigns").preview_hunk, desc = "Preview hunk" }
  nmap { "<leader>gd", require("gitsigns").preview_hunk_inline, desc = "Diff inline" }
  nmap { "<leader>gD", Core.utils.toggle_gitsigns_diff, desc = "Diff last commit" }
  nmap { "gh", require("gitsigns").select_hunk, desc = "Select git hunk", mode = { "o", "x" } }
  nmap { "<leader>gc", Snacks.picker.git_log, desc = "Commits" }
  nmap { "<leader>gs", Snacks.picker.git_status, desc = "Status" }
  nmap { "<leader>gH", Snacks.picker.git_diff, desc = "Hunks" }
  nmap { "<leader>gb", Snacks.git.blame_line, desc = "Blame line" }
  nmap { "<leader>gB", Snacks.gitbrowse.open, desc = "Browser" }

  -- session management -----------------------------------------
  nmap {
    "<leader>ql",
    function()
      require("core").session.load { dir = vim.fn.getcwd() }
    end,
    desc = "Restore Session for Current Directory",
  }
  nmap { "<leader>qs", require("core").session.pick, desc = "Select Session" }
  nmap { "<leader>qL", require("core").session.load, desc = "Restore Last Session" }
  nmap {
    "<leader>qd",
    function()
      Core.session.delete(vim.fn.getcwd())
    end,
    desc = "Delete Session for Curent Directory",
  }

  nmap { "<leader>fp", Core.utils.project_picker, desc = "Projects" }

  nmap {
    "<leader>fd",
    function()
      Core.utils.project_picker {
        projects = { "/etc", "/usr/local", "~/.ssh", "~/.local/bin", "~/.config" },
        title = "Directory",
      }
    end,
    desc = "Directory",
  }

  -- oil directory explorer -------------------------------------
  nmap { "<leader>e", require("oil").open, desc = "Explorer Parent" }
  nmap {
    "<leader>E",
    function()
      require("oil").open(vim.fs.root(0, { ".git", "pyproject.toml" }))
    end,
    desc = "Explorer Root",
  }
  -- flash -----------------------------------------------
  map { "s", require("flash").jump, mode = { "n", "x", "o" }, desc = "Jump" }
  map { "S", require("flash").treesitter, mode = { "n", "o", "x" }, desc = "Treesitter" }
  map { "r", require("flash").remote, mode = "o", desc = "Remote" }

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
  nmap { "<leader>,", Snacks.picker.buffers, desc = "Buffer" }
  nmap { "<leader>/", Snacks.picker.grep, desc = "Grep" }
  nmap { "<leader>:", Snacks.picker.command_history, desc = "Command History" }
  nmap { "<leader><space>", Snacks.picker.files, desc = "Files" }

  -- searching general ---------------------------------------------------------

  nmap { '<leader>s"', Snacks.picker.registers, desc = "Registers" }
  nmap { "<leader>sb", Snacks.picker.lines, desc = "Buffer" }
  nmap { "<leader>sB", Snacks.picker.grep_buffers, desc = "Buffers" }
  nmap { "<leader>sc", Snacks.picker.command_history, desc = "Command History" }
  nmap { "<leader>sC", Snacks.picker.commands, desc = "Commands" }
  nmap { "<leader>sD", Snacks.picker.diagnostics, desc = "Diagnostics" }
  nmap { "<leader>sd", Snacks.picker.diagnostics_buffer, desc = "Buffer Diagnostics" }
  nmap { "<leader>sg", Snacks.picker.grep, desc = "Grep (Root Dir)" }
  nmap { "<leader>sh", Snacks.picker.help, desc = "Help Pages" }
  nmap { "<leader>sj", Snacks.picker.jumps, desc = "Jumplist" }
  nmap { "<leader>sk", Snacks.picker.keymaps, desc = "Key Maps" }
  nmap { "<leader>sM", Snacks.picker.man, desc = "Man Pages" }
  nmap { "<leader>sm", Snacks.picker.marks, desc = "Jump to Mark" }
  nmap { "<leader>sR", Snacks.picker.resume, desc = "Resume" }
  nmap { "<leader>sq", Snacks.picker.qflist, desc = "Quickfix List" }
  nmap { "<leader>sw", Snacks.picker.grep_word, desc = "Word (Root Dir)", mode = { "n", "x" } }
  nmap { "<leader>ss", Snacks.picker.lsp_symbols, desc = "Symbols" }
  nmap {
    "<leader>sS",
    function()
      Snacks.picker.lsp_symbols { workspace = true }
    end,
    desc = "Workspace Symbols",
  }
  nmap { "<leader>su", Snacks.picker.undo, desc = "Undotree" }
  -- searching lsp -------------------------------------------------------------
  nmap {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "LSP Definition",
  }
  nmap { "gr", Snacks.picker.lsp_references, desc = "LSP References", nowait = true }
  nmap { "gI", Snacks.picker.lsp_implementations, desc = "LSP Implementations" }
  nmap { "gD", Snacks.picker.lsp_type_definitions, desc = "LSP Type Definitions" }

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
    nmap {
      "<leader>gg",
      function()
        toggle_terminal("lazygit", 100):toggle()
      end,
      desc = "Lazygit",
    }
    nmap {
      "<leader>gl",
      function()
        toggle_terminal("lazygit log", 101):toggle()
      end,
      desc = "Lazygit Log",
    }
    nmap {
      "<leader>gf",
      function()
        local file = vim.trim(vim.api.nvim_buf_get_name(0))
        toggle_terminal("lazygit log -f " .. file, 102):toggle()
      end,
      desc = "Lazygit Current File History",
    }
  end
  -- snacks -----------------------------------------------------------

  nmap { "<leader>H", Snacks.dashboard.open, desc = "Dashboard" }
  nmap { "leadercR", Snacks.rename.rename_file, desc = "Rename File" }
  map {
    "[r",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    mode = { "n", "t" },
    desc = "Reference",
  }
  map {
    "]r",
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
      require("sidekick.cli").focus { name = "opencode" }
    end,
    desc = "Sidekick Focus",
    mode = { "n", "t", "i", "x" },
  }
  nmap { "<leader>as", require("sidekick.cli").select, desc = "Select CLI" }
  nmap { "<leader>ad", require("sidekick.cli").close, desc = "Detach a CLI Session" }
  nmap {
    "<leader>at",
    function()
      require("sidekick.cli").send { msg = "{this}", name = "opencode" }
    end,
    mode = { "x", "n" },
    desc = "Send This",
  }
  nmap {
    "<leader>af",
    function()
      require("sidekick.cli").send { msg = "{file}", name = "opencode" }
    end,
    desc = "Send File",
  }
  nmap {
    "<leader>av",
    function()
      require("sidekick.cli").send { msg = "{selection}", name = "opencode" }
    end,
    mode = { "x" },
    desc = "Send Visual Selection",
  }
  nmap { "<leader>ap", require("sidekick.cli").prompt, mode = { "n", "x" }, desc = "Select Prompt" }

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

  ---------------------- yanky ----------------------
  nmap { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } }
  nmap { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } }

  nmap { "]p", "<Plug>(YankyPutIndentAfterLinewise)" }
  nmap { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" }
  nmap { "]P", "<Plug>(YankyPutIndentAfterLinewise)" }
  nmap { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" }
  nmap { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" }
  nmap { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" }
  nmap { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" }
  nmap { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" }
  nmap { "=p", "<Plug>(YankyPutAfterFilter)" }
  nmap { "=P", "<Plug>(YankyPutBeforeFilter)" }

  nmap { "<c-p>", "<Plug>(YankyPreviousEntry)" }
  nmap { "<c-n>", "<Plug>(YankyNextEntry)" }
end)
