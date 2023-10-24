require("oil").setup({
  keymaps = {
    ["<BS>"] = "actions.parent",
    ["q"] = "actions.close",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
  },
  float = {
    padding = 10,
    win_options = {
      winblend = 10,
    },
  },
})
