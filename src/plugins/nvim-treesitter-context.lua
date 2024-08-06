local context = require("treesitter-context")
context.setup({
  mode = "cursor",
  max_lines = 3,
})

local desc = "Toggle context"
Hosaka.nmap_leader("ot", function()
  context.toggle()
  local state = context.enabled()
  vim.notify(desc .. " " .. (state and "on" or "off"))
  Hosaka.nmap_leader_desc(desc .. " " .. (state and "off" or "on"))
end, desc .. " " .. (context.enabled() and "off" or "on"))
