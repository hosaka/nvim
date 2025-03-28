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
