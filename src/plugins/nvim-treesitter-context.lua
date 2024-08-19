local context = require("treesitter-context")
context.setup({
  mode = "cursor",
  max_lines = 3,
})

Hosaka.toggle.map("ot", {
  name = "context",
  get = function()
    return context.enabled()
  end,
  set = function()
    context.toggle()
  end,
})
