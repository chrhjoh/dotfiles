return {
  "windwp/nvim-autopairs",
  -- Optional dependency
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    require("nvim-autopairs").setup({})
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local handlers = require("nvim-autopairs.completion.handlers")
    local utils = require("nvim-autopairs.utils")
    local cmp = require("cmp")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        filetypes = {
          ["python"] = {
            ["("] = {
              handler = function(char, item, bufnr, rules, commit_character)
                local line = utils.text_get_current_line(bufnr)
                if line:match("^(from.*import.*)$") then
                  return
                end
                handlers["python"](char, item, bufnr, rules, commit_character)
              end,
            },
          },
        },
      })
    )
  end,
}
