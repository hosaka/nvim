-- custom comments
vim.bo.comments = ":---,:--"

-- custom textobjects
vim.b.minai_config = {
  custom_textobjects = {
    s = { "%[%[().-()%]%]" },
  },
}

-- custom surround
vim.b.minisurround_config = {
  custom_surroundings = {
    s = { input = { "%[%[().-()%]%]" }, output = { left = "[[", right = "]]" } },
  },
}

local lsp = "lua_ls"
if not vim.lsp.is_enabled(lsp) then
  vim.notify("Enabling " .. lsp .. " LSP")
  vim.lsp.enable(lsp)
end
