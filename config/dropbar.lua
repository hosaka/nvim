local map, mapl = Hosaka.keymap.map, Hosaka.keymap.mapl

require("dropbar").setup({
  bar = {
    pick = {
      pivots = "hjklasdfqweruiopzxcvm",
    },
  },
  menu = {
    win_configs = {
      border = "rounded",
    },
    entry = {
      padding = {
        left = 0,
        right = 1,
      },
    },
  },
})

mapl(";", [[<cmd>lua require("dropbar.api").pick()<cr>]], { desc = "Buffer symbols" })
