# Neovim Configuration

## WHAT: Repository Overview

Personal Neovim configuration that provides a modern IDE experience. Written entirely in Lua following modern Neovim best practices.

### Tech Stack

- **Language**: Lua (Neovim 0.8+)
- **Plugin Manager**: lazy.nvim
- **LSP Management**: Mason + mason-lspconfig
- **Formatter**: conform.nvim (oxfmt, stylua)
- **Linter**: nvim-lint (eslint_d)
- **Completion**: nvim-cmp + GitHub Copilot
- **Fuzzy Finder**: Telescope
- **Syntax Highlighting**: Treesitter
- **Version Control**: Gitsigns + Diffview

### Key Features

- LSP support: TypeScript, Lua, HTML, CSS, C/C++, Arduino
- GitHub Copilot AI-assisted coding
- Auto-formatting on save
- Fuzzy file finding and live grep
- Git integration with visual diffs
- Auto-completion with snippets
- Session management
- Space as leader key

---

## WHY: Structure & Organization

Modular structure separating concerns for easy maintenance.

```
nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin versions
├── .stylua.toml                # Lua formatter config
│
├── lua/abeluzhenko/
│   ├── lazy.lua                # Plugin manager bootstrap
│   │
│   ├── core/                   # Core Neovim configuration
│   │   ├── init.lua            # Loads keymaps and options
│   │   ├── keymaps.lua         # Custom key mappings
│   │   └── options.lua         # Editor settings
│   │
│   └── plugins/                # Plugin configs (one per file)
│       ├── init.lua            # Basic utilities
│       ├── [28+ plugins].lua   # Individual configs
│       │
│       └── lsp/                # Language Server configs
│           ├── mason.lua       # LSP installer
│           ├── lspconfig.lua   # LSP configurations
│           ├── none-ls.lua     # Non-LSP sources
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
- Indentation: 2 spaces, expand tabs
- Search: smart case
- UI: cursor line, colors, clipboard integration
- Splits: right/below, no swapfile

**`keymaps.lua`** (lua/abeluzhenko/core/keymaps.lua):
- Leader: `<Space>`
- Insert mode escape: `jk`
- Window management: `<leader>s[v|h|e|x]`
- Tab management: `<leader>t[o|x|n|p|f]`
- Abbreviations: `dvo` (DiffviewOpen), `dvh` (DiffviewFileHistory), `gs` (Gitsigns)

#### `lua/abeluzhenko/plugins/`
28+ plugin configuration files organized by purpose:

**UI & Navigation**: nvim-tree, telescope, bufferline, lualine, alpha-nvim, which-key, incline-nvim

**Editing**: nvim-cmp, copilot.lua, nvim-autopairs, nvim-surround, comment.lua, inc-rename-nvim

**Code Intelligence**: nvim-treesitter, nvim-treesitter-text-objects, treesitter-context, lsp-signature

**Formatting & Linting**: formatting.lua (conform.nvim), linting.lua (nvim-lint)

**Git**: gitsigns.lua, diffview.lua

**Visual**: colorscheme.lua (nightfly), colorizer.lua, dressing.lua, nvim-web-devicons

**Workflow**: auto-session.lua, outline.lua, vim-maximizer

Each plugin file returns a lazy.nvim spec with repository, dependencies, config, and keymaps.

#### `lua/abeluzhenko/plugins/lsp/`

**`mason.lua`** (lua/abeluzhenko/plugins/lsp/mason.lua):
- Auto-installs LSP servers: ts_ls, html, cssls, lua_ls, emmet_ls, arduino_language_server, clangd
- Auto-installs tools: oxfmt, stylua, eslint_d

**`lspconfig.lua`**: Configures LSP servers with keybindings (go to definition, references, etc.)

**`none-ls.lua`**: Bridge for non-LSP formatters/linters (being phased out)

#### `lua/abeluzhenko/lazy.lua`
Plugin manager bootstrap:
1. Auto-installs lazy.nvim if missing
2. Imports plugins from `abeluzhenko.plugins` and `abeluzhenko.plugins.lsp`
3. Enables update checking
4. Initializes Copilot

#### `after/queries/ecma/`
Custom Treesitter text objects for JavaScript/TypeScript:
- `@property.lhs` - Property key
- `@property.rhs` - Property value
- `@property.inner` - Value only
- `@property.outer` - Full property

### Configuration Philosophy

**Modular**: One file per plugin for easy enable/disable

**Lazy Loading**: Plugins load on-demand for fast startup

**Convention**: Follows Lua module conventions for auto-import

**Separation**: core/ (editor), plugins/ (features), plugins/lsp/ (language support), after/ (overrides)

---

## HOW: Scripts & Execution

### Running the Configuration

No executable scripts. This is a configuration repository.

```bash
# 1. Install Neovim 0.8+
nvim --version

# 2. Clone to config directory (backup existing config first)
git clone <repo-url> ~/.config/nvim

# 3. Launch Neovim - lazy.nvim auto-installs
nvim
```

### First Launch

Lazy.nvim automatically:
1. Clones itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Installs all plugins from `plugins/` and `plugins/lsp/`
3. Mason installs LSP servers and tools

Post-install:
- Authenticate Copilot: `:Copilot auth`
- Treesitter parsers compile in background

### Common Commands

```vim
:Lazy         " Plugin manager UI
:Mason        " LSP installer UI
:checkhealth  " Config health check
:LspInfo      " Show attached LSPs
```

### Maintenance

**Update plugins**:
```vim
:Lazy sync
```

**Update LSP servers**:
```vim
:Mason        " Press 'u' to update
```

**Format code**:
- Manual: `<leader>mp` (normal/visual mode)
- Auto: Saves automatically format (lua/abeluzhenko/plugins/formatting.lua:24)

**Git operations**:
```vim
:dvo          " DiffviewOpen
:dvh          " DiffviewFileHistory
:gs           " Gitsigns commands
```

### Customization

**Add plugin**:
1. Create `lua/abeluzhenko/plugins/your-plugin.lua`
2. Return lazy.nvim spec:
   ```lua
   return {
     "author/plugin-name",
     config = function()
       -- setup
     end,
   }
   ```
3. Restart Neovim

**Modify keybindings**:
- Global: Edit `lua/abeluzhenko/core/keymaps.lua`
- Plugin-specific: Edit plugin file

**Change settings**: Edit `lua/abeluzhenko/core/options.lua`

**Add LSP language**:
1. Add server to `lua/abeluzhenko/plugins/lsp/mason.lua:30`
2. Configure in `lua/abeluzhenko/plugins/lsp/lspconfig.lua`
3. Restart

**Change formatter**:
- Edit `lua/abeluzhenko/plugins/formatting.lua:9` (formatters_by_ft)
- Ensure tool installed via Mason

### File Locations

- **Plugins**: `~/.local/share/nvim/lazy/`
- **LSP servers**: `~/.local/share/nvim/mason/`
- **Sessions**: `~/.local/share/nvim/sessions/`

### Troubleshooting

**Plugins not loading**:
```vim
:Lazy reload <plugin-name>
```

**LSP not working**:
```vim
:LspInfo              " Check attachment
:Mason                " Verify installation
:checkhealth lsp      " Diagnostics
```

**Formatting issues**:
```vim
:ConformInfo          " Check formatter status
```

**Slow startup**:
```vim
:Lazy profile         " Identify slow plugins
```

### Key Bindings Reference

**Telescope** (`<leader>f`):
- `ff` - Find files
- `fr` - Recent files
- `fs` - Live grep
- `fc` - Grep word under cursor
- `fh` - Search history
- `fp` - Resume search

**Window** (`<leader>s`):
- `sv` - Split vertical
- `sh` - Split horizontal
- `se` - Equal size
- `sx` - Close split

**Tabs** (`<leader>t`):
- `to` - New tab
- `tx` - Close tab
- `tn` - Next tab
- `tp` - Previous tab

---

## Summary

Fully-featured Neovim IDE with 28+ plugins, LSP support, AI assistance via Copilot, git integration, and auto-formatting. Modular Lua configuration with lazy loading for fast startup. No build scripts required - launch `nvim` and everything initializes automatically.
