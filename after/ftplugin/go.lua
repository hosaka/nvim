local lsp = "gopls"
if not vim.lsp.is_enabled(lsp) then
  vim.lsp.enable({ lsp })
end
