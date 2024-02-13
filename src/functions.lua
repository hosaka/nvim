Hosaka.new_scratch_buffer = function()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buffer)
  return buffer
end

Hosaka.toggle_quickfix = function()
  local quickfix = vim.tbl_filter(function(win_id)
    return vim.fn.getwininfo(win_id)[1].quickfix == 1
  end, vim.api.nvim_tabpage_list_wins(0))
  local command = #quickfix == 0 and "copen" or "cclose"
  vim.cmd(command)
end

Hosaka.toggle_lazygit = function()
  -- FIXME: terminal is created every time, should have this persisted
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
  lazygit:toggle()
end
