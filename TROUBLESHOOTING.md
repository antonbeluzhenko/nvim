# Troubleshooting Guide

## Plugins Not Loading

### Reload a Specific Plugin

```vim
:Lazy reload <plugin-name>
```

### Check Plugin Status

```vim
:Lazy
```

This opens the lazy.nvim UI showing all plugins, their status, and any errors.

### Clear and Reinstall Plugins

```vim
:Lazy clean
:Lazy install
```

## LSP Issues

### Check LSP Attachment

```vim
:checkhealth vim.lsp
```

Shows which LSP servers are attached to which buffers, plus their root dirs and
capabilities. Note that current nvim-lspconfig no longer ships `:LspInfo`,
`:LspLog`, or `:LspRestart` — servers are started by `vim.lsp.enable()` in
`lua/abeluzhenko/plugins/lsp/lspconfig.lua`, and the health check replaces them.

Quick client list for the current buffer:

```vim
:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
```

### Mason Fails to Install isort / black / pylint

```
Failed to find a python3 installation in PATH that meets the required
versions (>=3.10.0). Found version: 3.9.6.
```

Mason builds the Python tools in a venv and rejects the macOS system Python
(3.9). Install Homebrew's `python3` formula — the unversioned one, since
`brew install python@3.12` puts only `python3.12` on `PATH` and leaves
`python3` pointing at the system 3.9:

```bash
brew install python3
python3 --version   # must report 3.10+
```

Then run `:MasonToolsUpdate`. Until it is fixed, mason-tool-installer retries
on every startup and logs this error to `~/.local/state/nvim/mason.log`.

### Verify LSP Server Installation

```vim
:Mason
```

Opens Mason UI to check installed LSP servers and tools. Remember the servers
come from two lists in `plugins/lsp/mason.lua` (mason-lspconfig for servers,
mason-tool-installer for tools including `tsgo`). `:MasonToolsUpdate` re-runs
the tool list.

### Restart LSP Server

Use the `<leader>rs` keymap — it stops the buffer's clients and re-edits the
file so the enabled servers re-attach. Equivalent manually:

```vim
:lua for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do c:stop(true) end
:edit
```

### View LSP Logs

```vim
:lua vim.cmd.tabnew(vim.lsp.get_log_path())
```

### TypeScript Server Not Starting

JS/TS is served by `tsgo`, which `lspconfig.lua` launches as
`tsgo --lsp --stdio` off `PATH`. If it never attaches, confirm the binary
resolves (`:echo exepath("tsgo")`) and reinstall with `:MasonInstall tsgo`.

## Formatting Issues

### Check Formatter Status

```vim
:ConformInfo
```

Shows available formatters for the current buffer and their status.

### Manual Format

```vim
:lua require("conform").format()
```

Or use the keymap: `<leader>mp` (format current buffer, or the selection in
visual mode).

### Wrong Formatter Runs

Web filetypes use a `stop_after_first` chain: `oxfmt`, then `prettierd`, then
`prettier`. Whichever is found first on `PATH` wins, so a missing `oxfmt`
silently falls through to prettier. `:ConformInfo` shows which are available.
Formatting also falls back to the LSP (`lsp_fallback = true`) when no configured
formatter is available.

## Treesitter Issues

> nvim-treesitter is on the `main` branch. It requires the `tree-sitter` CLI to
> compile parsers (see SETUP.md → Prerequisites).

### Check Treesitter Status

```vim
:checkhealth nvim-treesitter
```

List installed parsers:

```vim
:lua =require("nvim-treesitter.config").get_installed()
```

### Syntax Highlighting Missing / Wrong

Usually means the parser failed to compile. Check `:TSLog` for errors like
`Error during "tree-sitter build": ENOENT (cmd): 'tree-sitter'` — that means the
`tree-sitter` CLI is not installed or not on Neovim's `PATH`. Install it
(`npm install -g tree-sitter-cli`), confirm `tree-sitter --version` works in the
shell you launch Neovim from, then re-run `:TSUpdate`.

Highlighting is started per-buffer via a `FileType` autocmd in
`lua/abeluzhenko/plugins/nvim-treesitter.lua`; confirm the parser is installed
and the buffer's `filetype` is set.

### Update Treesitter Parsers

```vim
:TSUpdate
```

### Reinstall Parser

```vim
:TSInstall <language>
```

## Performance Issues

### Check Startup Time

```vim
:Lazy profile
```

Identifies which plugins are slowing down startup.

### Measure Startup Time (Terminal)

```bash
nvim --startuptime startup.log
```

Then review `startup.log` to see what takes time.

## Copilot Issues

> Inline (ghost text) suggestions and the Copilot panel are **disabled by
> design** in `plugins/copilot.lua`. Copilot shows up as a nvim-cmp completion
> source via copilot-cmp — missing ghost text is not a bug.

### Check Copilot Status

```vim
:Copilot status
```

### Re-authenticate Copilot

```vim
:Copilot auth
```

### Restart Copilot

```vim
:Copilot disable
:Copilot enable
```

## General Diagnostics

### Full Health Check

```vim
:checkhealth
```

Runs comprehensive diagnostics on all components.

### Check Neovim Version

```vim
:version
```

Ensure you're running Neovim 0.11+ (required by nvim-treesitter's `main` branch).

## Common Issues

### "Module not found" Error

1. Check file path matches module name
2. Ensure file returns a value/table
3. Restart Neovim

### Keybindings Not Working

1. Check for conflicts: `:verbose map <key>`
2. Verify leader key is set (should be Space)
3. Check which-key for binding info: `<Space>` (wait for popup)

### Colors Look Wrong

1. Check terminal supports true color
2. Verify colorscheme is installed
3. Try `:colorscheme nightfly` manually

### Auto-completion Not Working

1. Check nvim-cmp is loaded: `:Lazy`
2. Verify LSP is attached: `:checkhealth vim.lsp`
3. Check Copilot status: `:Copilot status`
4. For missing Copilot entries specifically, confirm a `copilot` client is
   running — copilot-cmp only registers its source on `InsertEnter`/`LspAttach`
   once copilot.lua has attached:
   ```vim
   :lua =#vim.lsp.get_clients({ name = "copilot" })
   ```
