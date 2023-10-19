-- custom comments
vim.opt_local.comments = ":---,:--"

-- custom textobjects
vim.b.minai_config = {
  custom_textobjects = {
    s = { "%[%[().-()%]%]" },
  },
}

-- custom  surround
vim.b.minisurround_config = {
  custom_surroundings = {
    s = { input = { "%[%[().-()%]%]" }, output = { left = "[[", right = "]]" } },
  },
}
