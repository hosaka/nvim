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
    markdown = { "prettier" },
    python = { "isort", "black" },
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
  },
})

vim.g.autoformat_disable = false
vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

vim.keymap.set({ "n", "x" }, "<Leader>cf", [[<cmd>lua require("conform").format()<cr>]], { desc = "Format code" })

vim.api.nvim_create_user_command("Format", function(args)
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
