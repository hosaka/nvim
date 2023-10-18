require("oil").setup({
  keymaps = {
    ["<BS>"] = "actions.parent",
    ["q"] = "actions.close",
  },
  float = {
    padding = 10,
    win_options = {
      winblend = 10,
    },
  },
})
