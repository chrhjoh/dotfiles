return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    --- @param sc string
    --- @param txt string
    --- @param keybind string? optional
    --- @param keybind_opts table? optional
    local function button(sc, txt, keybind, keybind_opts)
      local sc_ = sc:gsub("%s", ""):gsub(dashboard.leader, "<leader>")
      local if_nil = vim.F.if_nil
      local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "AlphaShortcut",
        hl = "AlphaButton",
      }
      if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
      end

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
      end

      return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
      }
    end
    -- Set header
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.header.val = {
      "                                                                               ",
      "              ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗               ",
      "              ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║               ",
      "              ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║               ",
      "              ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║               ",
      "              ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║               ",
      "              ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝               ",
      "                                                                               ",
      "                                                                               ",
      "                                                                               ",
    }
    -- Set menu
    dashboard.section.buttons.val = {
      button("s", "  > Restore session", '<cmd>SessionSelect<cr>'),
      button("f", "  > Find file", ':lua require("fzf-lua").files()<CR>'),
      button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
      button("o", "  > Open Recent Files", ':lua require("fzf-lua").oldfiles()<CR>'),
      button("t", "  > Open File Tree", ':lua require("neo-tree.command").execute{}<CR>'),
      button("u", "󰂖  > Update Plugins", ":Lazy update<CR>"),
      button("c", "  > Open Configurations", ":e $MYVIMRC | :cd %:p:h | pwd<CR>"),
      button("n", "󱓧  > Search Notes", "<cmd>ObsidianSearch<CR>"),
      button("N", "󱓧  > Choose Note Workspace", "<cmd>ObsidianWorkspace<CR>"),
      button("q", "󰗼  > Quit NVIM", ":qa<CR>"),
    }
    -- Send config to alpha
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.config.layout = {
      { type = "padding", val = 1 },
      dashboard.section.header,
      dashboard.section.buttons,
      dashboard.section.footer,
      { type = "padding", val = 1 },
    }
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local count = (math.floor(stats.startuptime * 100) / 100)
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        dashboard.section.footer.val = {
          "󱐌 " .. stats.count .. " plugins loaded in " .. count .. " ms",
          datetime .. nvim_version_info,
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
