-- format on save can be disabled with a global or buffer-local variable
-- vim.g.autoformat_disable = true
-- vim.b[buffer].autoformat_disable = true

-- use conform as formatexpr, which allows formatting with `gq` operator
vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

require("conform").setup({
  format_on_save = function(buffer)
    if vim.g.autoformat_disable or vim.b[buffer].autoformat_disable then
      return
    end
    -- disable for certain filetypes
    local ignore_filetypes = {}
    if vim.tbl_contains(ignore_filetypes, vim.bo[buffer].filetype) then
      return
    end
    -- disable for files in certain paths
    local bufname = vim.api.nvim_buf_get_name(buffer)
    if bufname:match("/node_modules/") then
      return
    end
    return {
      timeout_ms = 3000,
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
    markdown = { "prettier", "injected" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    yaml = { "prettier" },
  },
  -- custom formatters
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
    injected = {
      ignore_errors = false,
    },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.api.nvim_create_user_command("Conform", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ range = range })
end, { range = true })

-- <cmd> does not switch modes so : is used instead
vim.keymap.set({ "n", "x" }, "<Leader>cf", [[:Conform<cr>]], { desc = "Format code" })
