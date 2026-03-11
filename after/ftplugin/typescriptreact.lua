if not vim.lsp.is_enabled("vtsls") then
  vim.lsp.enable({ "vtsls" })
end

if not vim.lsp.is_enabled("eslint") then
  vim.lsp.enable({ "eslint" })
end
