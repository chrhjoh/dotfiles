local move_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Move" }
local wez_paste_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "WezTerm" }
local terminal_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Terminal" }

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
    keys = function()
      return move_map {
        {
          "<C-h>",
          "<cmd>TmuxNavigateLeft<cr>",
          desc = "Pane Left",
        },
        {
          "<C-j>",
          "<cmd>TmuxNavigateDown<cr>",
          desc = "Pane Down",
        },
        {
          "<C-k>",
          "<cmd>TmuxNavigateUp<cr>",
          desc = "Pane Up",
        },
        {
          "<C-l>",
          "<cmd>TmuxNavigateRight<cr>",
          desc = "Pane Right",
        },
      }
    end,
  },
  {
    "chrhjoh/wezterm-paster.nvim",
    cmd = { "WezTermPanePaste", "WezTermPaneSelect" },
    opts = {},
    keys = function()
      return wez_paste_map {
        {
          "<leader>tp",
          "<cmd>WezTermPanePaste<cr>",
          desc = "Paste to Pane",
          mode = { "n", "v" },
        },
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
      open_mapping = [[<c-\>]],
      close_on_exit = true,
      shading_ratio = 0.5,
      winbar = { enabled = true },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local toggleterm_mappings = vim.api.nvim_create_augroup("ToggleTermMappings", { clear = true })
      vim.api.nvim_create_autocmd("TermOpen", {
        group = toggleterm_mappings,
        pattern = "term://*toggleterm#*",
        callback = function()
          local keymap_opts = { buffer = 0 }
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], keymap_opts)
          vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], keymap_opts)
          vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], keymap_opts)
        end,
      })
    end,
    keys = function()
      return terminal_map {
        { "<c-\\>" },
        {
          "<leader>tx",
          function()
            require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count })
          end,
          desc = "Send Current Line",
          mode = "n",
        },
        {
          "<leader>tx",
          function()
            require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count })
          end,
          desc = "Send Selected Lines",
          mode = "v",
        },
        {
          "<leader>tX",
          function()
            require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
          end,
          desc = "Send Selection",
          mode = "v",
        },
        {
          "<leader>t|",
          function()
            require("toggleterm").toggle(vim.v.count, 60, nil, "vertical")
          end,
          desc = "Open Vertical",
        },
        {
          "<leader>t-",
          function()
            require("toggleterm").toggle(vim.v.count, 18, nil, "horizontal")
          end,
          desc = "Open Horizontal",
        },
        {
          "<leader>tf",
          function()
            require("toggleterm").toggle(vim.v.count, nil, nil, "float")
          end,
          desc = "Open Float",
        },
        {
          "<leader>gg",
          function()
            local terminal = require("toggleterm.terminal").Terminal
            local lazygit = terminal:new { cmd = "lazygit", hidden = true, direction = "float", close_on_exit = true }
            lazygit:open()
          end,
          desc = "Lazygit",
        },
        {
          "<leader>gl",
          function()
            local terminal = require("toggleterm.terminal").Terminal
            local lazygit =
              terminal:new { cmd = "lazygit log", hidden = true, direction = "float", close_on_exit = true }
            lazygit:open()
          end,
          desc = "Lazygit Log",
        },
        {
          "<leader>gf",
          function()
            local file = vim.trim(vim.api.nvim_buf_get_name(0))
            local terminal = require("toggleterm.terminal").Terminal
            local lazygit =
              terminal:new { cmd = "lazygit -f " .. file, hidden = true, direction = "float", close_on_exit = true }
            lazygit:open()
          end,
          desc = "Lazygit Current File History",
        },
      }
    end,
  },
}
