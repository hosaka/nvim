local lsp = "yamlls"
if not vim.lsp.is_enabled(lsp) then
  vim.lsp.enable({ lsp })
end
