vim.pack.add {
  { src = "https://github.com/windwp/nvim-autopairs", version = "master" },
  { src = "https://github.com/numToStr/Comment.nvim", version = "master" },
  { src = "https://github.com/folke/todo-comments.nvim", version = "main" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors", version = "main" },
}

Config.load.load_eager_if_arg(function()
  require("todo-comments").setup {}
end)

Config.load.load_on_event({ "BufReadPost", "BufNewFile" }, function()
  require("Comment").setup {} ---@diagnostic disable-line: missing-fields

  require("nvim-highlight-colors").setup {
    enable_hex = true,
    enable_short_hex = false,
    enable_rgb = true,
    enable_hsl = true,
    enable_var_usage = true,
    enable_named_colors = true,
    enable_tailwind = false,
  }
end)
Config.load.load_on_event("InsertEnter", function()
  require("nvim-autopairs").setup {}
end)
