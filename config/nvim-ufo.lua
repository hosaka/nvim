local ufo = require("ufo")
local map = Hosaka.keymap.map

map("zR", [[<cmd>lua require("ufo").openAllFolds()<cr>]], { desc = "Open all folds" })
map("zM", [[<cmd>lua require("ufo").closeAllFolds()<cr>]], { desc = "Close all folds" })

ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
})
