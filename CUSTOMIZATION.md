# Customization Guide

## Adding a Plugin

1. Create a new file in `lua/abeluzhenko/plugins/your-plugin.lua`

2. Return a lazy.nvim spec:
   ```lua
   return {
     "author/plugin-name",
     config = function()
       -- setup code here
     end,
   }
   ```

3. Restart Neovim

The plugin will be automatically loaded by lazy.nvim due to the convention-based import system.

## Modifying Keybindings

### Global Keybindings

Edit `lua/abeluzhenko/core/keymaps.lua` for editor-wide keymaps.

Example:
```lua
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
```

### Plugin-Specific Keybindings

Edit the specific plugin file in `lua/abeluzhenko/plugins/`.

Most plugins define keymaps in their `keys` field or within the `config` function.

## Changing Settings

Edit `lua/abeluzhenko/core/options.lua` to modify editor behavior.

Common options:
```lua
opt.number = true              -- Show line numbers
opt.tabstop = 2                -- Tab width
opt.shiftwidth = 2             -- Indent width
opt.expandtab = true           -- Use spaces instead of tabs
```

## Adding LSP Language Support

1. Add the LSP server to `lua/abeluzhenko/plugins/lsp/mason.lua` around line 30:
   ```lua
   ensure_installed = {
     "ts_ls",
     "html",
     "cssls",
     "lua_ls",
     "your_new_server", -- Add here
   }
   ```

2. Configure the server in `lua/abeluzhenko/plugins/lsp/lspconfig.lua`:
   ```lua
   lspconfig["your_new_server"].setup({
     capabilities = capabilities,
     on_attach = on_attach,
   })
   ```

3. Restart Neovim

Mason will automatically install the new LSP server.

## Changing Formatter

1. Edit `lua/abeluzhenko/plugins/formatting.lua` at line 9 (`formatters_by_ft`):
   ```lua
   formatters_by_ft = {
     javascript = { "prettier" },
     typescript = { "prettier" },
     lua = { "stylua" },
     python = { "black" },  -- Add your formatter
   }
   ```

2. Ensure the formatter tool is installed via Mason by adding it to `lua/abeluzhenko/plugins/lsp/mason.lua`:
   ```lua
   ensure_installed = {
     -- ... other tools ...
     "black",  -- Add your formatter tool
   }
   ```

3. Restart Neovim

## Changing Theme

Edit `lua/abeluzhenko/plugins/colorscheme.lua` to change the color scheme:

1. Replace the plugin repository
2. Update the colorscheme name in the config function

Example:
```lua
return {
  "folke/tokyonight.nvim",
  config = function()
    vim.cmd("colorscheme tokyonight")
  end,
}
```

## Disabling a Plugin

To disable a plugin without deleting the file, add `enabled = false`:

```lua
return {
  "author/plugin-name",
  enabled = false,
  config = function()
    -- ...
  end,
}
```
