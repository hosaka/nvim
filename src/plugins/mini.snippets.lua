local minisnippets = require("mini.snippets")
local gen_loader = minisnippets.gen_loader
local snippets_path = vim.fn.stdpath("config") .. "/misc/snippets"

minisnippets.setup({
  snippets = {
    gen_loader.from_file(snippets_path .. "/all.json"),
    gen_loader.from_lang(),
  },
})
