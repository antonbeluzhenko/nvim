-- Cargo.toml helper: version hints, completion, hover and code actions for
-- crates, served through an in-process LSP (picked up by cmp's nvim_lsp source)
return {
  "saecki/crates.nvim",
  version = "^0.7.0",
  event = { "BufRead Cargo.toml" },
  opts = {
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
  },
}
