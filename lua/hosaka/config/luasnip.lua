local luasnip = require("luasnip")
luasnip.config.set_config({ history = true })

-- load local snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/misc/snippets" } })
