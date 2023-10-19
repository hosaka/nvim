hosaka.toggle_lazygit = function()
  -- FIXME: terminal is created every time, should have this persisted
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
  lazygit:toggle()
end
