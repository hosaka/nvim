require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = {
    enabled = false,
  },
  exclude = {
    filetypes = {
      "help",
      "mason",
      "notify",
      "toggleterm",
    },
  },
})
