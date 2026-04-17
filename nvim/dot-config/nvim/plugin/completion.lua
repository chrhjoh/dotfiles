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
      ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      },
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
