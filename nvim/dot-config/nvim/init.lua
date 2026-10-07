vim.loader.enable()
_G.Core = require("core")

local function update_blink(kind)
  if kind == "delete" then
    return
  end
  vim.cmd.packadd("blink.cmp")
  local download = require("blink.cmp.fuzzy.download")
  -- Required for bootstrap as blink is loaded on insert enter
  download.ensure_downloaded(function(err)
    if err then
      print("Failed to install blink.cmp fuzzy finder:", err)
    else
      print("Successfully installed blink.cmp fuzzy finder")
    end
  end)
end

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
    elseif name == "blink.cmp" then
      update_blink(kind)
    end
  end,
})
