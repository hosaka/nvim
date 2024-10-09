local miniclue = require("mini.clue")
miniclue.setup({
  window = {
    config = {
      width = "auto",
      border = "rounded",
    },
    scroll_down = "<c-n>",
    scroll_up = "<c-p>",
  },
  triggers = {
    -- leader
    { mode = "n", keys = "<leader>" },
    { mode = "x", keys = "<leader>" },
    -- built-in
    { mode = "i", keys = "<c-x>" },
    -- goto
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    -- marks
    { mode = "n", keys = "'" },
    { mode = "x", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "`" },
    -- nav
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },
    -- registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<c-r>" },
    { mode = "c", keys = "<c-r>" },
    -- window
    { mode = "n", keys = "<c-w>" },
    -- z key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },
  clues = {
    Config.leader_group_clues,
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({
      submode_move = true,
      submode_resize = true,
    }),
    miniclue.gen_clues.z(),
  },
})
