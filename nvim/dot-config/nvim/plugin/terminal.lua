vim.pack.add { { src = "https://github.com/akinsho/toggleterm.nvim", version = vim.version.range("*") } }

local function setup()
  require("toggleterm").setup {
    open_mapping = false, -- Register is self
    close_on_exit = true,
    winbar = { enabled = true },
  }
  local esc_timers = {}

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
      vim.keymap.set("n", "q", function()
        require("toggleterm").toggle(id)
      end, keymap_opts)
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
end

Config.load.load_lazily(setup)
