require("conform").setup({
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
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
