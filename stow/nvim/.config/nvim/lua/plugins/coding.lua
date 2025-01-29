local nmap = Utils.keymap.get_lazy_list_mapper { mode = "n", desc_prefix = "Neogen" }
return {
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
    },
    --stylua: ignore
    keys = function()
      return nmap{
          { "<leader>cn", function() require("neogen").generate() end, desc = "Generate Annotations" },
      }
    end,
  },
}
