vim.loader.enable()
_G.Config = require("core")

local function update_treesitter(kind)
  if kind == "delete" then
    return
  end
  vim.cmd.packadd("nvim-treesitter")
  local TS = require("nvim-treesitter")
  TS.update()

  if kind == "update" then
    return
  end

  local ensure_installed = {
    "lua",
    "python",
    "rust",
    "vimdoc",
    "vim",
    "bash",
    "markdown",
    "markdown_inline",
    "julia",
    "snakemake",
    "json",
    "toml",
    "sql",
    "latex",
    "toml",
    "gitcommit",
    "yaml",
    "regex",
    "diff",
  }

  local installed = TS.get_installed()
  local to_install = vim.tbl_filter(function(parser)
    return not vim.list_contains(installed, parser)
  end, ensure_installed)
  TS.install(to_install):wait(300000)
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" then
      update_treesitter(kind)
    end
  end,
})
