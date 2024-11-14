local remap = Hosaka.keymap.remap

-- remap built-in open filepath/URI keymap before setup
remap("gx", "<Leader>rx", { desc = "Open filepath or URI" })
remap("gx", "<Leader>rx", { mode = "x", desc = "Open filepath or URI" })

require("mini.operators").setup()
