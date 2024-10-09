local ai = require("mini.ai")
ai.setup({
  custom_textobjects = {
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    m = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
  },
})
