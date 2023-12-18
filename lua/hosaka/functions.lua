-- Helper table
local H = {}

-- Functions for managing startup. Basically both are `try-catch` implementing
-- "two step startup": some should execute immediately and some - later
-- (strictly preserving order and not blocking in between).
hosaka.now = function(f)
  local ok, err = pcall(f)
  if not ok then
    table.insert(H.exec_errors, err)
  end
  H.schedule_finish()
end

H.later_callback_queue = {}

hosaka.later = function(f)
  table.insert(H.later_callback_queue, f)
  H.schedule_finish()
end

H.finish_is_scheduled = false

H.schedule_finish = function()
  if H.finish_is_scheduled then
    return
  end
  vim.schedule(H.finish)
  H.finish_is_scheduled = true
end

H.finish = function()
  local timer, step_delay = vim.uv.new_timer(), 1
  local f = nil
  f = vim.schedule_wrap(function()
    local callback = H.later_callback_queue[1]
    if callback == nil then
      H.finish_is_scheduled = false
      H.report_errors()
      return
    end

    table.remove(H.later_callback_queue, 1)
    hosaka.now(callback)
    timer:start(step_delay, 0, f)
  end)
  timer:start(step_delay, 0, f)
end

H.exec_errors = {}

H.report_errors = function()
  if #H.exec_errors == 0 then
    return
  end
  local msg = "There were errors during startup:\n\n" .. table.concat(H.exec_errors, "\n\n")
  vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, {})
end

hosaka.toggle_lazygit = function()
  -- FIXME: terminal is created every time, should have this persisted
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
  lazygit:toggle()
end
