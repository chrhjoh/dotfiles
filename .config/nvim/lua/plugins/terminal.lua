local move_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Move" }
local wez_paste_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "WezTerm" }
local terminal_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Terminal" }

local esc_timers = {}
local lazygit = nil
local lazygit_log = nil
local lazygit_filelog = nil
local lazygit_yadm = nil

local function hidden_terminal(cmd, id)
  local terminal = require("toggleterm.terminal").Terminal
  return terminal:new {
    cmd = cmd,
    hidden = true,
    direction = "float",
    close_on_exit = true,
    id = id,
  }
end

local double_press_escape = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.b[bufnr].esc_timer_id then
    table.insert(esc_timers, vim.uv.new_timer())
    vim.b[bufnr].esc_timer_id = #esc_timers
  end
  local timer = esc_timers[vim.b[bufnr].esc_timer_id]
  if timer:is_active() then
    timer:stop()
    vim.cmd("stopinsert")
  else
    timer:start(200, 0, function() end)
    -- https://github.com/neovim/neovim/issues/12312
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

local move = function(direction)
  if vim.env.TMUX then
    if direction == "h" then
      vim.cmd("TmuxNavigateLeft")
    end
    if direction == "j" then
      vim.cmd("TmuxNavigateDown")
    end
    if direction == "k" then
      vim.cmd("TmuxNavigateUp")
    end
    if direction == "l" then
      vim.cmd("TmuxNavigateRight")
    end
  end
  require("wezterm-move").move(direction)
end

return {
  { "letieu/wezterm-move.nvim", lazy = true },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    --stylua: ignore
    keys = function()
      return move_map {
        {  "<C-h>",  function() move("h")  end,  desc = "Pane Left",} ,
        {  "<C-j>",  function() move("j")  end,  desc = "Pane Down",} ,
        {  "<C-k>",  function() move("k")  end,  desc = "Pane Up",} ,
        {  "<C-l>",  function() move("l")  end,  desc = "Pane Right",} ,
      }
    end,
  },
  {
    "chrhjoh/wezterm-paster.nvim",
    cmd = { "WezTermPanePaste", "WezTermPaneSelect" },
    opts = {},
    --stylua: ignore
    keys = function()
      return wez_paste_map {
        { "<leader>tp", "<cmd>WezTermPanePaste<cr>",  desc = "Paste to Pane",  mode = { "n", "v" },} ,
        { "<leader>tP", "<cmd>WezTermPaneSelect<cr>", desc = "Select Pane" },
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = true,
    cmd = "ToggleTerm",
    --  ---@type ToggleTermConfig
    opts = {
      open_mapping = false, -- Register is self
      close_on_exit = true,
      winbar = { enabled = true },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local toggleterm_custom = vim.api.nvim_create_augroup("ToggleTermCustom", { clear = true })

      --- Sets keymaps on startup of new terminal
      vim.api.nvim_create_autocmd("TermOpen", {
        group = toggleterm_custom,
        pattern = "term://*toggleterm#*",
        callback = function(args)
          local id = vim.b[args.buf].toggle_number
          local keymap_opts = { buffer = args.buf }
          vim.keymap.set("t", "<esc>", function()
            double_press_escape()
          end, keymap_opts)
          vim.keymap.set({ "t", "n" }, "<C-\\>", function()
            local term = vim.v.count ~= 0 and vim.v.count or id -- Toggle itself unless other count is specified
            require("toggleterm").toggle(term)
          end, keymap_opts)
          vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], keymap_opts)
        end,
      })
      --- Cleanup if buffer is deleted (untested)
      vim.api.nvim_create_autocmd("BufWipeout", {
        group = toggleterm_custom,
        pattern = "term://*toggleterm#*",
        callback = function(args)
          local bufnr = args.buf
          if not vim.b[bufnr].esc_timer_id then
            return
          end
          local timer_id = vim.b[bufnr].esc_timer_id
          if timer_id and esc_timers[timer_id] then
            esc_timers[timer_id]:stop()
            esc_timers[timer_id]:close()
            esc_timers[timer_id] = nil
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = toggleterm_custom,
        pattern = "term://*toggleterm#*",
        callback = function(args)
          -- needs defer for some reason. Seems like the window is not fully entered at time of "BufEnter"
          vim.defer_fn(function()
            vim.cmd("startinsert")
          end, 10)
        end,
      })
    end,
    --stylua: ignore
    keys = function()
      return terminal_map {
        { "<c-\\>",     function()   require("toggleterm").toggle(vim.v.count) end,                                                       desc = "Toggle",              mode = "n",},
        { "<leader>tx", function()   require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count1 }) end,      desc = "Send Current Line",   mode = "n",},
        { "<leader>tx", function()   require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count1 }) end,     desc = "Send Selected Lines", mode = "v",},
        { "<leader>tX", function()   require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count1 }) end, desc = "Send Selection",      mode = "v",},
        { "<leader>t|", function()   require("toggleterm").toggle(vim.v.count1, 60, nil, "vertical") end,                                 desc = "Open Vertical",},
        { "<leader>t-", function()   require("toggleterm").toggle(vim.v.count1, 18, nil, "horizontal") end,                               desc = "Open Horizontal",},
        { "<leader>tf", function()   require("toggleterm").toggle(vim.v.count1, nil, nil, "float") end,                                   desc = "Open Float",},
        { "<leader>gg", function()   lazygit = lazygit or hidden_terminal("lazygit", 100)            lazygit:toggle() end,                desc = "Lazygit",},
        { "<leader>gy", 
          function()
            lazygit_yadm = lazygit_yadm or hidden_terminal('lazygit --work-tree $HOME --git-dir $XDG_DATA_HOME/yadm/repo.git/' , 101)
            lazygit_yadm:toggle() 
          end,
          desc = "Lazygit - Yadm dotfiles",
        },
        { "<leader>gl", function()   lazygit_log = lazygit_log or hidden_terminal("lazygit log",102) lazygit_log:toggle()end,             desc = "Lazygit Log",},
        { "<leader>gf",
          function()
            local file = vim.trim(vim.api.nvim_buf_get_name(0))
            lazygit_filelog = lazygit_filelog or hidden_terminal("lazygit log -f " .. file, 103)
            lazygit_filelog:toggle()
          end,
          desc = "Lazygit Current File History",
        },
      }
    end,
  },
}
