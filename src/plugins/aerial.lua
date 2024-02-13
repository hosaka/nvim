require("aerial").setup({
  attach_mode = "global",
  backends = { "lsp", "treesitter", "markdown", "man" },
  layout = {
    min_width = 42,
  },
  show_guides = true,
  filter_kind = false,
})
