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

`lua/abeluzhenko/plugins/lsp/mason.lua` has **two** `ensure_installed` lists —
pick the right one:

- `mason_lspconfig.setup()` (line ~30) takes **lspconfig server names** and is
  where most servers go.
- `mason_tool_installer.setup()` (line ~42) takes **Mason package names** and
  is where formatters, linters, and any server mason-lspconfig has no mapping
  for (e.g. `tsgo`) go.

1. Add the server to the appropriate list:
   ```lua
   ensure_installed = {
     "html",
     "cssls",
     "lua_ls",
     "your_new_server", -- Add here
   }
   ```

2. Configure and enable the server in
   `lua/abeluzhenko/plugins/lsp/lspconfig.lua` using the Neovim 0.11 API:
   ```lua
   vim.lsp.config("your_new_server", {
     capabilities = capabilities,
     on_attach = on_attach,
   })
   ```

   Then add its name to the single `vim.lsp.enable({...})` call at the bottom
   of the file — a server that is configured but not enabled never starts:
   ```lua
   vim.lsp.enable({
     "html",
     "tsgo",
     -- ...
     "your_new_server",
   })
   ```

   For a server that is not in nvim-lspconfig's catalog, also pass `cmd`,
   `filetypes`, and `root_markers` (see the `tsgo` block for an example).

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

2. Ensure the formatter tool is installed via Mason by adding it to the
   **`mason_tool_installer.setup()`** list in
   `lua/abeluzhenko/plugins/lsp/mason.lua` (line ~42 — not the
   mason-lspconfig list above it):
   ```lua
   ensure_installed = {
     -- ... other tools ...
     "black",  -- Add your formatter tool
   }
   ```

   A formatter that is not a Mason package has to be on `PATH` by other means.
   Formatters listed together for one filetype are a fallback chain when
   `stop_after_first = true` — e.g. web files try `oxfmt`, then `prettierd`,
   then `prettier`. Custom invocation (like `oxfmt`, which does not read
   stdin) goes in the `formatters = {}` table below `formatters_by_ft`.

3. Restart Neovim

## Changing Theme

Edit `lua/abeluzhenko/plugins/colorscheme.lua` to change the color scheme.
nightfly is active; a fully configured tokyonight spec is commented out in the
same file — swapping is a matter of commenting one block and uncommenting the
other.

1. Replace the plugin repository
2. Update the colorscheme name in the config function
3. Update `install.colorscheme` in `lua/abeluzhenko/lazy.lua`, which still
   names `nightfly`

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
