local context = require("treesitter-context")
context.setup({
  mode = "cursor",
  max_lines = 3,
})

Hosaka.toggle({
  name = "context",
  get = context.enabled,
  set = context.toggle,
}):mapl("ot")
