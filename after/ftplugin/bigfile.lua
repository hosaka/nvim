-- disable features for `bigfile` type
local buffer = vim.api.nvim_get_current_buf()

vim.schedule(function()
  vim.notify(string.format("Some plugins disabled for files larger than %s bytes", vim.g.bigfile_size))
  vim.bo[buffer].syntax = vim.filetype.match({ buf = buffer }) or ""
end)
