-- Rust support. rustaceanvim owns the rust-analyzer client: it is configured
-- via vim.lsp.config("rust-analyzer", ...) in lsp/lspconfig.lua and must not
-- be passed to vim.lsp.enable(). rust-analyzer is resolved off PATH (install
-- it with rustup or Homebrew, not Mason, so it matches the toolchain).
return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false, -- the plugin lazy-loads itself on the rust filetype
}
