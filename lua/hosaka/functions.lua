hosaka.toggle_lazygit = function()
  -- FIXME: terminal is created every time, should have this persisted
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
  lazygit:toggle()
end

--- Load a plugin and load it's config if available.
---@param plugin string
hosaka.load = function(plugin)
  vim.cmd(string.format([[packadd %s]], plugin))
  local ok, res = pcall(require, "hosaka.config." .. plugin)
  -- if not ok then
  --   vim.notify(res, vim.log.levels.ERROR)
  -- end
  if type(res) == "string" and string.find(res, "module 'hosaka.config") then
    vim.notify("module not found", vim.log.levels.WARN)
  elseif not ok then
    vim.notify(res, vim.log.levels.ERROR)
  end
end

--- Load a plugin sometime soon.
---@param plugin string
hosaka.lazy = function(plugin)
  vim.schedule(function()
    hosaka.load(plugin)
  end)
end
