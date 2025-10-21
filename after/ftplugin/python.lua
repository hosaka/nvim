vim.cmd([[setlocal colorcolumn=89]])

vim.b.miniindentscope_config = { options = { border = "top" } }

local lsp = "ruff"
if not vim.lsp.is_enabled(lsp) then
  vim.lsp.enable({ lsp, "ty", "basedpyright" })
end
