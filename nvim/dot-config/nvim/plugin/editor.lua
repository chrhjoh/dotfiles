vim.pack.add {
  { src = "https://github.com/windwp/nvim-autopairs", version = "master" },
  { src = "https://github.com/numToStr/Comment.nvim", version = "master" },
  { src = "https://github.com/folke/todo-comments.nvim", version = "main" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors", version = "main" },
}

local setup_on_buffer = function()
  require("Comment").setup {}
  require("nvim-highlight-colors").setup {
    enable_hex = true,
    enable_short_hex = false,
    enable_rgb = true,
    enable_hsl = true,
    enable_var_usage = true,
    enable_named_colors = true,
    enable_tailwind = false,
  }
end

Config.load.load_on_event(setup_on_buffer, { "BufReadPost", "BufNewFile" })
Config.load.load_on_event(function()
  require("nvim-autopairs").setup {}
end, "InsertEnter")

Config.load.load_lazily(function()
  require("todo-comments").setup {}
end)
