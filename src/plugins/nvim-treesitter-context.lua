local context = require("treesitter-context")
context.setup({
  mode = "cursor",
  max_lines = 3,
})

require("hosaka.toggle")({
  name = "context",
  get = context.enabled,
  set = context.toggle,
}):mapl("ot")
