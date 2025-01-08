local move_map = Utils.keymap.get_mapper { mode = "n", desc_prefix = "Move" }
local wez_paste_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "WezTerm" }
local snoggle_map = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Snoggle" }
---@alias Direction "h"|"j"|"k"|"l"
---@param direction Direction
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
-- Navigation between windows

move_map {
  "<C-h>",
  function()
    move("h")
  end,
  desc = "Pane Left",
}
move_map {
  "<C-j>",
  function()
    move("j")
  end,
  desc = "Pane Down",
}
move_map {
  "<C-k>",
  function()
    move("k")
  end,
  desc = "Pane Up",
}
move_map {
  "<C-l>",
  function()
    move("l")
  end,
  desc = "Pane Right",
}

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
    "chrhjoh/snoggleterm.nvim",
    lazy = true,
    dependencies = { "folke/snacks.nvim" },
    keys = function()
      return snoggle_map {
        {
          "<leader>tt",
          function()
            require("snoggleterm").toggle_terminal()
          end,
          desc = "Toggle",
          { expr = true },
        },
        {
          "<leader>tf",
          function()
            require("snoggleterm").toggle_floating_terminal()
          end,
          desc = "Toggle - Float",
        },
        {
          "<leader>t|",
          function()
            require("snoggleterm").spawn_terminal("right")
          end,
          desc = "Spawn - Right",
        },
        {
          "<leader>t-",
          function()
            require("snoggleterm").spawn_terminal("bottom")
          end,
          desc = "Spawn - Bottom",
        },
        {
          "<leader>tr",
          function()
            require("snoggleterm").spawn_terminal("bottom", "python3")
          end,
          desc = "Spawn REPL",
        },

        {
          "<C-\\>",
          function()
            require("snoggleterm").toggle_terminal()
          end,
          desc = "Toggle",
        },
      }
    end,
  },
}
