require("avante_lib").load()
require("avante").setup({
  provider = "openai",
  behaviour = {
    -- see `src/leadermaps.lua` for keymaps
    auto_set_keymaps = false,
  },
})
