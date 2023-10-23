require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "goimports" },
    dockerfile = { "hadolint" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    handlebars = { "prettier" },
  },
  -- custom formatters
  formatters = {
    -- dprint = {
    --   condition = function (ctx)
    --     return vim.fs.find({"dprint.json"}, { path = ctx.filename, upward = true})[1]
    --   end
    -- }
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
