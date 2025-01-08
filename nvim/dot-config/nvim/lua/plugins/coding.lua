return {
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
    },
    keys = function()
      local nmap = Utils.keymap.get_lazy_mapper { mode = "n", desc_prefix = "Neogen" }

      return {
        nmap {
          "<leader>cn",
          function()
            require("neogen").generate()
          end,
          desc = "Generate Annotations",
        },
      }
    end,
  },
}
