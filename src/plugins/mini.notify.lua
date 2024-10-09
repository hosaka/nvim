local notify = require("mini.notify")
local notify_filter = function(notif_arr)
  local lua_ls = function(notif)
    return not (vim.startswith(notif.msg, "lua_ls: Diagnosing") or vim.startswith(notif.msg, "lua_ls: Processing"))
  end
  notif_arr = vim.tbl_filter(lua_ls, notif_arr)
  return notify.default_sort(notif_arr)
end
local window_config = function()
  local has_statusline = vim.o.laststatus > 0
  local padding = vim.o.cmdheight + (has_statusline and 1 or 0)
  return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - padding, border = "rounded" }
end
notify.setup({
  content = {
    format = function(notif)
      return notif.msg
    end,
    sort = notify_filter,
  },
  window = {
    config = window_config,
  },
})
vim.notify = notify.make_notify()
