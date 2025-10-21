local lsp = "taplo"
if not vim.lsp.is_enabled(lsp) then
  vim.notify("Enabling " .. lsp)
  vim.lsp.enable(lsp)
end
