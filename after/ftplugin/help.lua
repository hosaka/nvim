vim.opt_local.foldenable = false

-- enable clues in help buffers
if _G.MiniClue then
  MiniClue.enable_buf_triggers(vim.api.nvim_get_current_buf())
end
