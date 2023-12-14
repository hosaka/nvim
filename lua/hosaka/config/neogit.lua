require("neogit").setup({
  kind = "split",
  graph_style = "unicode",
  disable_hint = true,
  disable_commit_confirmation = true,
  integrations = {
    diffview = true
  }
})
