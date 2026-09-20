return {
  "williamboman/mason.nvim",
  version = "^1.0.0",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "html",
        "cssls",
        "lua_ls",
        "emmet_ls",
        "arduino_language_server",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- mason-lspconfig has no mapping for tsgo, so it is installed here
        -- by its mason package name instead
        "tsgo", -- typescript language server (lspconfig.lua runs it off PATH)
        "oxfmt", -- js/ts formatter (conform's first choice)
        "prettierd", -- formatter (faster prettier)
        "prettier", -- formatter
        "stylua", -- lua formatter
        "eslint_d", -- js linter
        "isort", -- python import sorter
        "black", -- python formatter
        "pylint", -- python linter
      },
    })
  end,
}
