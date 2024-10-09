local remap = Hosaka.remap

-- remap built-in open filepath/URI keymap before setup
remap("n", "gx", "<Leader>rx", "Open filepath or URI")
remap("x", "gx", "<Leader>rx", "Open filepath or URI")

require("mini.operators").setup()
