return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python", "snakemake" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = false,
      },
    },
  },
}
