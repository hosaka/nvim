require("conform").setup({
  format_on_save = function(buffer)
    if vim.g.autoformat_disable or vim.b[buffer].autoformat_disable then
      return
    end
    local bufname = vim.api.nvim_buf_get_name(buffer)
    if bufname:match("/node_modules/") then
      return
    end
    return {
      async = true,
      timeout_ms = 10000,
      lsp_fallback = true,
    }
  end,
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
    vue = { "prettier" },
    yaml = { "prettier" },
  },
  -- custom formatters
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
})

vim.g.autoformat_disable = false
vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
