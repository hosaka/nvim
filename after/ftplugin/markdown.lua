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
