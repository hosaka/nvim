require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
    repeat_linebreak = false,
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
