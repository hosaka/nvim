-- disable features for `bigfile` type
local buffer = vim.api.nvim_get_current_buf()

vim.notify(string.format("Some plugins disabled for files larger than %s bytes", vim.g.bigfile_size))

vim.b.minihhipatterns_disable = true

vim.schedule(function()
  if vim.api.nvim_buf_is_valid(buffer) then
    vim.bo[buffer].syntax = vim.filetype.match({ buf = buffer }) or ""
  end
end)
