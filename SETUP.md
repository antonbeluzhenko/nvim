# Setup Guide

## First Launch

When you launch Neovim for the first time, lazy.nvim will automatically:

1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install all plugins from `plugins/` and `plugins/lsp/`
3. Mason installs LSP servers and tools

## Post-Install Steps

### Authenticate GitHub Copilot

```vim
:Copilot auth
```

Follow the browser prompts to authenticate your GitHub account.

### Treesitter Parsers

Treesitter parsers compile automatically in the background. You can check their status:

```vim
:TSInstallInfo
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

3. Test completion by opening a file and typing - you should see suggestions

4. Test formatting by editing a file and saving (auto-format on save is enabled)
