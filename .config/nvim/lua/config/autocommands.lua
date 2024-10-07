local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local spell_group = vim.api.nvim_create_augroup("Spell", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = spell_group,
  pattern = { "*.md", "*.tex", "*.typ" },
  command = "setlocal spell"
})
