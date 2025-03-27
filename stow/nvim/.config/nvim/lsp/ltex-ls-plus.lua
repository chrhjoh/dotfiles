local language_id_mapping = {
  bib = "bibtex",
  pandoc = "markdown",
  plaintex = "tex",
  rnoweb = "rsweave",
  rst = "restructuredtext",
  tex = "latex",
  text = "plaintext",
}

local function get_language_id(_, filetype)
  return language_id_mapping[filetype] or filetype
end

return {
  default_config = {
    cmd = { "ltex-ls-plus" },
    filetypes = {
      "bib",
      "context",
      "gitcommit",
      "html",
      "markdown",
      "org",
      "pandoc",
      "plaintex",
      "quarto",
      "mail",
      "mdx",
      "rmd",
      "rnoweb",
      "rst",
      "tex",
      "text",
      "typst",
      "xhtml",
    },
    single_file_support = true,
    get_language_id = get_language_id,
    settings = {
      ltex = {
        enabled = {
          "bib",
          "context",
          "gitcommit",
          "html",
          "markdown",
          "org",
          "pandoc",
          "plaintex",
          "quarto",
          "mail",
          "mdx",
          "rmd",
          "rnoweb",
          "rst",
          "tex",
          "latex",
          "text",
          "typst",
          "xhtml",
        },
      },
    },
  },
}
