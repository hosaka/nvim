-- note: a lot of mappings are defined by mini.basics, see `init.lua`
-- note: the rest off the <Leader> mappings are defined in `leadermaps.lua`

-- paste above/below linewise
vim.keymap.set({ "n", "x" }, "[p", [[<cmd>exe 'put! ' . v:register<cr>]], { desc = "Paste above", silent = true })
vim.keymap.set({ "n", "x" }, "]p", [[<cmd>exe 'put ' . v:register<cr>]], { desc = "Paste below", silent = true })

-- cancel search highlight
vim.keymap.set({ "i", "n" }, [[<Esc>]], [[<cmd>nohlsearch<cr><esc>]], { desc = "Cancel search", silent = true })

-- delete empty lines to blackhole
vim.keymap.set("n", "dd", function()
  if vim.fn.getline(".") == "" then
    return '"_dd'
  end
  return "dd"
end, { expr = true })
