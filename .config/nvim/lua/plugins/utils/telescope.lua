local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "fbuchlak/telescope-directory.nvim" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        persisted = {
          layout_config = {
            width = 0.5,
            height = 0.5,
          },
        },
      },
      defaults = {
        mappings = {
          i = {
            ["<CR>"] = select_one_or_multi,

          },
          n = {
            ["<C-D>"] = require("telescope.actions").delete_buffer,
          }, -- n
        },
      },
    })
    require("telescope").load_extension("persisted")
    require("telescope").load_extension("directory")
    require("telescope").load_extension("aerial")
    require("telescope").load_extension("fzf")
  end,
  keys = {
    {
      "<leader>sb",
      function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "Fuzzily [S]earch in current [B]uffer",
    },
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[S]earch [/] in Open Files",
    },
    {
      "<leader>ss",
      function()
        require("telescope").extensions.persisted.persisted()
      end,
      desc = "[S]earch [S]essions",
    },
    {
      "<leader>gf",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "[G]it [F]ind",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({ no_ignore = true })
      end,
      desc = "[F]iles [F]ind",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "[R]ecent [F]iles",
    },
    {
      "<leader>bf",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "[B]uffer [F]ind",
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>sw",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sG",
      ":LiveGrepGitRoot<cr>",
      desc = "[S]earch by [G]rep on Git Root",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "[S]earch [D]iagnostics",
    },
    {
      "<leader>sl",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[S]earch [L]ast resume",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          no_ignore = true,
          hidden = true,
        })
      end,
      desc = "[S]earch [A]ll files",
    },
    {
      "<Leader>sd",
      function()
        require("telescope").extensions.directory.live_grep({}) -- find_files|grep_string|live_grep
      end,
      desc = "[S]earch [D]irectory",
    },
    {
      "<Leader>fd",
      function()
        require("telescope").extensions.directory.find_files({}) -- find_files|grep_string|live_grep
      end,
      desc = "[F]iles in [D]irectory",
    },
    {
      "<leader>fc",
      function()
        local CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
        local fk_opts = {
          cwd = CONFIG_HOME,
          results_title = "Config",
        }
        require("telescope.builtin").find_files(fk_opts)
      end,
      desc = "[F]ile [C]onfig",
    },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>",        desc = "Commands" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>",     desc = "Options" },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").lsp_document_symbols({})
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({})
      end,
      desc = "Goto Symbol (Workspace)",
    },

    {
      "<leader>sa",
      "<cmd>Telescope aerial<cr>",
      desc = "[S]earch Symbol ([A]erial)",
    },
  },
}
