require("conform").setup({
  format_on_save = {
    async = true,
    timeout_ms = 10000,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    css = { "prettier" },
    dockerfile = { "hadolint" },
    go = { "goimports" },
    graphql = { "prettier" },
    handlebars = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "isort", "black" },
    sh = { "shfmt" },
    typescript = { "prettier" },
    yaml = { "prettier" },
  },
  -- custom formatters
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
})

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
