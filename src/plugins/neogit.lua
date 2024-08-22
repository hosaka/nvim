require("neogit").setup({
  kind = "tab",
  graph_style = "unicode",
  disable_commit_confirmation = true,
  integrations = {
    diffview = true,
  },
  sections = {
    recent = {
      folded = false,
    },
  },
})
