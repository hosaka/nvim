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

  local prefix = "hosaka.config."

  local ok, res = pcall(require, prefix .. plugin)
  if not ok then
    if not string.find(res, "^module '" .. prefix) then
      vim.notify(res, vim.log.levels.ERROR)
    end
  end
end

--- Load a plugin sometime soon.
---@param plugin string
hosaka.lazy = function(plugin)
  vim.schedule(function()
    hosaka.load(plugin)
  end)
end
