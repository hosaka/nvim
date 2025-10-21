local lsp = "gopls"
if not vim.lsp.is_enabled(lsp) then
  vim.notify("Enabling " .. lsp .. " LSP")
  vim.lsp.enable(lsp)
end
