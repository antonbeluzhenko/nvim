return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        svelte = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        css = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        html = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        json = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        yaml = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        markdown = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        graphql = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      formatters = {
        oxfmt = {
          command = "oxfmt",
          args = { "$FILENAME" },
          stdin = false,
          -- When stdin=false, use this template to generate the temporary file that gets formatted
          tmpfile_format = ".conform.$RANDOM.$FILENAME",
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
