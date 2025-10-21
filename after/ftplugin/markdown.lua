vim.cmd([[setlocal spell wrap]])

-- custom textobjects
local has_miniai, miniai = pcall(require, "mini.ai")
if has_miniai then
  vim.b.miniai_config = {
    custom_textobjects = {
      ["*"] = miniai.gen_spec.pair("*", "*", { type = "greedy" }),
      ["_"] = miniai.gen_spec.pair("_", "_", { type = "greedy" }),
    },
  }
end

-- disable "show table of contents" on nvim>=0.11 in favour
-- of `gO` from 'mini.basics'
pcall(vim.keymap.del, "n", "gO", { buffer = 0 })

vim.b.minisurround_config = {
  custom_surroundings = {
    -- markdown link, usage:
    -- `saiwL` - add link
    -- `sdL` - delete link
    -- `srLL` - replace link
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}

local lsp = "marksman"
if not vim.lsp.is_enabled(lsp) then
  vim.lsp.enable({ lsp })
end
