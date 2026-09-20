# Neovim Configuration

## WHAT: Repository Overview

Personal Neovim configuration that provides a modern IDE experience. Written entirely in Lua following modern Neovim best practices.

### Tech Stack

- **Language**: Lua (Neovim 0.11+ — required by both the `vim.lsp.config()`/
  `vim.lsp.enable()` API and nvim-treesitter's `main` branch)
- **Plugin Manager**: lazy.nvim
- **LSP Management**: Mason (pinned to `^1.0.0`) + mason-lspconfig + nvim-lspconfig
- **Formatter**: conform.nvim (oxfmt → prettierd → prettier for web files, stylua, isort/black)
- **Linter**: nvim-lint (eslint_d, pylint)
- **Completion**: nvim-cmp + LuaSnip + GitHub Copilot (via copilot.lua / copilot-cmp)
- **Fuzzy Finder**: Telescope (fzf-native, live-grep-args, ast-grep extensions)
- **Syntax Highlighting**: Treesitter (`main` branch)
- **Version Control**: Gitsigns + Diffview

### External Prerequisites

- **`tree-sitter` CLI** — required by nvim-treesitter's `main` branch, which
  compiles parsers from grammars on install (unlike the old `master` branch).
  Install with `npm install -g tree-sitter-cli` (or `cargo install tree-sitter-cli`).
  It must be on the `PATH` seen by Neovim. Note: Homebrew's `tree-sitter`
  formula ships only the library, not the CLI binary.
- **`tsgo`** — the TypeScript language server used for JS/TS, resolved off
  `PATH` (`vim.lsp.config("tsgo", { cmd = { "tsgo", "--lsp", "--stdio" } })`).
  Installed by Mason (`@typescript/native-preview`) via mason-tool-installer,
  so no manual step is needed.
- **Python 3.10+** — required for Mason to build `isort`, `black`, and
  `pylint`; the macOS system Python (3.9) is rejected. Install via
  `brew install python3` (the unversioned formula — `python@3.x` does not put
  `python3` on `PATH`).
- **`deno`** — used by peek.nvim's build step (`deno task build:fast`) for
  markdown preview.
- **`make`** — used by telescope-fzf-native's build step.

### Key Features

- LSP support: TypeScript/JavaScript (tsgo), Lua, HTML, CSS, Emmet, Arduino
- GitHub Copilot AI-assisted coding (completion source, not inline ghost text)
- Auto-formatting on save (conform.nvim)
- Fuzzy file finding, live grep, and live grep with args
- Git integration with visual diffs
- Auto-completion with snippets
- Treesitter text objects for select / swap / move
- Markdown preview (peek.nvim)
- Built-in vim trainers (vim-be-good, nvim-training)
- Space as leader key

---

## WHY: Structure & Organization

Modular structure separating concerns for easy maintenance.

```
nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin versions
├── .stylua.toml                # Lua formatter config (2-space indent)
│
├── lua/abeluzhenko/
│   ├── lazy.lua                # Plugin manager bootstrap
│   │
│   ├── core/                   # Core Neovim configuration
│   │   ├── init.lua            # Loads keymaps and options
│   │   ├── keymaps.lua         # Custom key mappings
│   │   └── options.lua         # Editor settings
│   │
│   └── plugins/                # Plugin configs (one per file, 32 files)
│       ├── init.lua            # Basic utilities (plenary, ReplaceWithRegister)
│       ├── [31 more].lua       # Individual configs
│       │
│       └── lsp/                # Language Server configs
│           ├── mason.lua       # LSP + tool installer
│           ├── lspconfig.lua   # LSP server configurations
│           └── mason-workaround.lua
│
└── after/
    └── queries/ecma/
        └── textobjects.scm     # Custom Treesitter text objects
```

### Directory Details

#### `init.lua` (Root)

Entry point loading:

1. Core settings (`abeluzhenko.core`)
2. Plugin manager (`abeluzhenko.lazy`)

#### `lua/abeluzhenko/core/`

Fundamental configurations independent of plugins:

**`options.lua`** (lua/abeluzhenko/core/options.lua):

- Line numbers: relative + absolute
- Indentation: 2 spaces, expand tabs, autoindent
- Search: ignorecase + smartcase
- UI: cursor line, termguicolors, dark background, always-on sign column
- Clipboard: `unnamedplus` (system clipboard)
- Splits: right/below, no swapfile, no line wrap

**`keymaps.lua`** (lua/abeluzhenko/core/keymaps.lua):

- Leader: `<Space>`
- Insert mode escape: `jk`
- `o`/`O` insert a line without continuing comments
- `<leader>nh` clear search highlights; `x` deletes without clobbering the register
- `<leader>+` / `<leader>-` increment/decrement number
- Window management: `<leader>s[v|h|e|x]`
- Tab management: `<leader>t[o|x|n|p|f]`
- Telescope: `<leader>f[f|r|s|g|c|h|p]` (`fg` = live_grep_args; `fa`/`fj` are commented out)
- Abbreviations: `dvo` (DiffviewOpen), `dvh` (DiffviewFileHistory), `gs` (Gitsigns)

Plugin-specific keymaps live in the plugin files, not here — e.g. `<leader>e*`
(nvim-tree), `<leader>mp` (conform format), `<leader>l` (nvim-lint),
`<leader>sm` (vim-maximizer), the treesitter text-object maps, and the LSP maps
in `on_attach`.

#### `lua/abeluzhenko/plugins/`

32 plugin configuration files organized by purpose:

**UI & Navigation**: nvim-tree, telescope (+ ast-grep, live-grep-args), bufferline, lualine, alpha-nvim, which-key, incline-nvim, vim-tmux-navigator

> **vim-tmux-navigator uses custom mappings.** Karabiner rewrites `ctrl+hjkl`
> into the plain arrow keys before Neovim sees them, so the plugin's built-in
> `<C-h/j/k/l>` bindings never fire. `vim-tmux-navigator.lua` sets
> `vim.g.tmux_navigator_no_mappings = 1` and declares both `<C-h/j/k/l>` and
> `<Left>/<Down>/<Up>/<Right>` in its lazy.nvim `keys` table (normal mode only,
> so arrows still move the cursor in insert/visual mode).
>
> See `lua/abeluzhenko/plugins/vim-tmux-navigator.lua`.

**Editing**: nvim-cmp (+ cmp-buffer, cmp-path, LuaSnip, friendly-snippets, lspkind), nvim-surround, inc-rename-nvim, vim-ReplaceWithRegister

**AI**: copilot.lua (inline suggestion + panel disabled), copilot-cmp (Copilot as a cmp source), copilot-status.nvim

**Code Intelligence**: nvim-treesitter (`main` branch, + nvim-ts-autotag), nvim-treesitter-text-objects, nvm-treesitter-context (filename typo is intentional/harmless), lsp-signature

> **nvim-treesitter is on the `main` branch**, which has a different API from
> the legacy `master` branch:
>
> - Parsers are installed via `require("nvim-treesitter").install({...})`
>   (async, compiles via the `tree-sitter` CLI) — not `ensure_installed`.
> - `setup()` only accepts `install_dir`; `highlight`/`indent`/`textobjects`/
>   `incremental_selection` keys are ignored.
> - Highlighting and indentation are started per-buffer in a `FileType`
>   autocmd (`vim.treesitter.start()` + treesitter `indentexpr`).
> - Textobjects use manual keymaps via the `nvim-treesitter-textobjects`
>   `select`/`swap`/`move` modules — all configured inside
>   `nvim-treesitter.lua`. `nvim-treesitter-text-objects.lua` is a bare
>   `lazy = true` stub to avoid a second `setup()` overwriting that config.
> - `incremental_selection` was removed with no built-in replacement.
>
> See `lua/abeluzhenko/plugins/nvim-treesitter.lua`.

**Formatting & Linting**: formatting.lua (conform.nvim), linting.lua (nvim-lint).
These are the only formatting/diagnostic providers — there is deliberately no
none-ls/null-ls layer, which would double-format on save and duplicate eslint_d
diagnostics. `oxfmt` moved into mason-tool-installer's `ensure_installed` when
the none-ls layer was removed, so conform's first-choice formatter is still
installed automatically.

**Git**: gitsigns.lua, diffview.lua

**Visual**: colorscheme.lua (nightfly active; tokyonight block commented out), colorizer.lua, nvim-web-devicons (custom GraphQL icon)

**Workflow & Misc**: vim-maximizer, peek-nvim (markdown preview), vim-be-good, nvim-training

Each plugin file returns a lazy.nvim spec with repository, dependencies, config, and keymaps.

#### `lua/abeluzhenko/plugins/lsp/`

**`mason.lua`** (lua/abeluzhenko/plugins/lsp/mason.lua):

- Pins `williamboman/mason.nvim` to `^1.0.0`
- Auto-installs LSP servers: `html`, `cssls`, `lua_ls`, `emmet_ls`,
  `arduino_language_server` — the same set `lspconfig.lua` enables, minus
  `tsgo` (see the tool list below)
- Auto-installs tools (mason-tool-installer): `tsgo`, `oxfmt`, `prettierd`,
  `prettier`, `stylua`, `eslint_d`, `isort`, `black`, `pylint`. `tsgo` lives
  here rather than in the server list because mason-lspconfig has no mapping
  for it; the Python three need `python3` ≥ 3.10 on `PATH` or Mason refuses to
  build them

**`lspconfig.lua`**: Configures servers with the Neovim 0.11 API —
`vim.lsp.config(name, {...})` per server, then a single `vim.lsp.enable({...})`.
Enabled: `html`, `tsgo`, `cssls`, `emmet_ls`, `lua_ls`,
`arduino_language_server`. Shared `on_attach` disables LSP semantic tokens (to
avoid fighting Treesitter highlighting), attaches lsp_signature, and sets
`gR`/`gd`/`gi`/`gt`, `<leader>ca`, `<leader>rn`, `<leader>D`, `<leader>d`, `K`,
`<leader>rs`. Diagnostic gutter signs are customized.

> `<leader>rs` stops the buffer's clients and re-edits the file rather than
> calling `:LspRestart` — current nvim-lspconfig no longer ships `:LspInfo`,
> `:LspLog`, or `:LspRestart`. Use `:checkhealth vim.lsp` in their place.

**`mason-workaround.lua`**: Pins the renamed `mason-org/mason.nvim` and
`mason-org/mason-lspconfig.nvim` to `^1.0.0` so the 2.x rewrite isn't pulled in.

#### `lua/abeluzhenko/lazy.lua`

Plugin manager bootstrap:

1. Auto-installs lazy.nvim (stable branch) if missing
2. Imports plugins from `abeluzhenko.plugins` and `abeluzhenko.plugins.lsp`
3. Sets install colorscheme to nightfly; enables the update checker and
   change detection, both with notifications off

Nothing is `require`d eagerly here — every plugin, Copilot included, is left to
its own lazy.nvim spec so its `opts` are the ones that take effect.

#### `after/queries/ecma/`

Custom Treesitter text objects for JavaScript/TypeScript (`; extends` the
upstream ecma queries):

- `@property.lhs` - Property key
- `@property.rhs` - Property value
- `@property.inner` - Value only
- `@property.outer` - Full property

Used by the `l:` / `r:` / `i:` / `a:` select keymaps and the `<leader>n:` /
`<leader>p:` swap keymaps in `nvim-treesitter.lua`.

### Configuration Philosophy

**Modular**: One file per plugin for easy enable/disable

**Lazy Loading**: Plugins load on-demand for fast startup

**Convention**: Follows Lua module conventions for auto-import

**Separation**: core/ (editor), plugins/ (features), plugins/lsp/ (language support), after/ (overrides)

---

## HOW: Working with This Configuration

### File Locations

- **Plugins**: `~/.local/share/nvim/lazy/`
- **LSP servers & tools**: `~/.local/share/nvim/mason/`
- **Treesitter parsers**: `~/.local/share/nvim/site/parser/`

### Task-Specific Guides

For detailed instructions on specific tasks, refer to these guides:

- **[SETUP.md](SETUP.md)** - First-time installation and post-install verification steps
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - How to add plugins, modify keybindings, add LSP languages, change formatters
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Debug commands and solutions for common issues
