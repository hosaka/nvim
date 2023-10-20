local luasnip = require("luasnip")
luasnip.config.set_config({
  history = true,
  delete_check_events = "TextChanged",
})

-- load local snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/misc/snippets" } })
