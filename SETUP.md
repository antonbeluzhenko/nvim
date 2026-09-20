# Setup Guide

## Prerequisites

- **Neovim 0.11+** — required both by nvim-treesitter's `main` branch and by
  the `vim.lsp.config()` / `vim.lsp.enable()` API used in
  `lua/abeluzhenko/plugins/lsp/lspconfig.lua`.
- **Node.js / npm** — Mason installs most of the servers and tools as npm
  packages, and GitHub Copilot needs a Node runtime.
- **Python 3.10+** — Mason needs it to install the Python tools (`isort`,
  `black`, `pylint`). macOS ships 3.9, which Mason rejects. Install
  Homebrew's:

  ```bash
  brew install python3
  ```

  Use the unversioned `python3` formula, **not** `python@3.x` — the versioned
  formulae only install `python3.12`-style binaries and keep the plain
  `python3` symlink inside their own `libexec/bin`, so `python3` on `PATH`
  stays at the system 3.9. Verify with `python3 --version`.
- **`tree-sitter` CLI** — nvim-treesitter's `main` branch compiles parsers from
  grammars on install, so the CLI must be installed and on Neovim's `PATH`:

  ```bash
  npm install -g tree-sitter-cli
  # or: cargo install tree-sitter-cli
  ```

  Verify with `tree-sitter --version`. Note: Homebrew's `tree-sitter` formula
  installs only the library, **not** the CLI binary.
- **`make`** — telescope-fzf-native is built from source on install.
- **`deno`** — peek.nvim (markdown preview) runs `deno task build:fast` on
  install. Skip it if you do not need `:PeekOpen`.

## First Launch

When you launch Neovim for the first time, lazy.nvim will automatically:

1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install all plugins from `plugins/` and `plugins/lsp/`
3. Mason installs the LSP servers and tools listed below

Mason handles two lists, both in `lua/abeluzhenko/plugins/lsp/mason.lua`:

- **Servers** (mason-lspconfig): `html`, `cssls`, `lua_ls`, `emmet_ls`,
  `arduino_language_server`
- **Tools** (mason-tool-installer): `tsgo`, `oxfmt`, `prettierd`, `prettier`,
  `stylua`, `eslint_d`, `isort`, `black`, `pylint`

`tsgo` is the TypeScript server and lives in the tools list because
mason-lspconfig has no mapping for it; `lspconfig.lua` runs it off `PATH`
(Mason's `bin/` is on Neovim's `PATH`).

## Post-Install Steps

### Authenticate GitHub Copilot

```vim
:Copilot auth
```

Follow the browser prompts to authenticate your GitHub account.

### Treesitter Parsers

On the `main` branch, parsers are compiled from grammars by the `tree-sitter`
CLI (see Prerequisites) and installed asynchronously in the background on first
launch. Check their status with:

```vim
:checkhealth nvim-treesitter
```

Or list installed parsers:

```vim
:lua =require("nvim-treesitter.config").get_installed()
```

## Verification

After initial setup, verify everything is working:

1. Check LSP servers are installed:
   ```vim
   :Mason
   ```

2. Check plugins are loaded:
   ```vim
   :Lazy
   ```

3. Check LSP clients attach to a buffer:
   ```vim
   :checkhealth vim.lsp
   ```

4. Test completion by opening a file and typing - you should see suggestions.
   Copilot appears as a nvim-cmp source, not as inline ghost text (inline
   suggestions and the panel are disabled in `plugins/copilot.lua`).

5. Test formatting by editing a file and saving (conform.nvim formats on save).
   `:ConformInfo` shows which formatter will run for the current buffer.
