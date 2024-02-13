-- NOTE: a lot of mappings are defined by mini.basics

local map = function(mode, key, cmd, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, key, cmd, opts)
end

-- paste above/below linewise
map({ "n", "x" }, "[p", [[<cmd>exe 'put! ' . v:register<cr>]], { desc = "Paste above" })
map({ "n", "x" }, "]p", [[<cmd>exe 'put ' . v:register<cr>]], { desc = "Paste below" })

-- cancel search highlight
map({ "i", "n" }, [[<Esc>]], [[<cmd>nohlsearch<cr><esc>]])

-- delete selection with backspace in select mode
map("s", [[<BS>]], [[<BS>i]])

-- terminal navigation
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Normal Mode" })
map("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Normal Mode Window" })
map("t", "<C-h>", [[<cmd>wincmd h<cr>]], { desc = "Go to Left Window" })
map("t", "<C-j>", [[<cmd>wincmd j<cr>]], { desc = "Go to Lower Window" })
map("t", "<C-k>", [[<cmd>wincmd k<cr>]], { desc = "Go to Upper Window" })
map("t", "<C-l>", [[<cmd>wincmd l<cr>]], { desc = "Go to Right Window" })
