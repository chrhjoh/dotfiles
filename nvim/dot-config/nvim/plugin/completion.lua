vim.pack.add {
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
  { src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
}

Config.load.load_on_event({ "CmdlineEnter", "InsertEnter" }, function()
  require("blink.cmp").setup {
    signature = { enabled = true },
    appearance = { nerd_font_variant = "normal" },
    completion = {
      keyword = { range = "full" },
      list = { selection = { auto_insert = false } },
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      trigger = {
        show_in_snippet = false,
      },
    },
    keymap = {
      preset = "none",
      ["<C-y>"] = { "show", "accept" },
      ["<C-e>"] = { "cancel" },
      ["<Tab>"] = {
        "snippet_forward",
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
        "select_next",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<S-Enter>"] = { "show", "accept" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = "inherit" },
      completion = {
        menu = {
          auto_show = true,
          draw = {
            columns = { { "label", "label_description", gap = 1 } },
          },
        },
        list = { selection = { auto_insert = false } },
        ghost_text = { enabled = false },
      },
    },
    sources = {
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  }
end)
