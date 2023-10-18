local default_opts = {
  noremap = true,
  silent = true,
  expr = false,
  nowait = false,
  script = false,
  unique = false,
}

-- NOTE: a lot of mappings are defined by mini.basics

local map = function(mode, key, cmd, opts)
  local opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.keymap.set(mode, key, cmd, opts)
end

-- disable s shortcut (use cl instead) in order to use mini.surround
map("n", "s", [[<Nop>]])
map("x", "s", [[<Nop>]])

-- paste above/below linewise
map({ "n", "x" }, "[p", [[<cmd>exe 'put! ' . v:register<cr>]], { desc = "Paste above" })
map({ "n", "x" }, "]p", [[<cmd>exe 'put ' . v:register<cr>]], { desc = "Paste below" })

-- switching buffers
map("n", "<S-h>", [[<cmd>bprevious<cr>]], { desc = "Prev buffer" })
map("n", "<S-l>", [[<cmd>bnext<cr>]], { desc = "Next buffer" })

-- cancel search highlight
map({ "i", "n" }, "<Esc>", [[<cmd>nohlsearch<cr><esc>]])

-- delete selection with backspace in select mode
map('s', [[<BS>]], [[<BS>i]])

-- terminals
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Normal Mode" })
map("t", "<C-h>", [[<cmd>wincmd h<cr>]], { desc = "Go to Left Window" })
map("t", "<C-j>", [[<cmd>wincmd j<cr>]], { desc = "Go to Lower Window" })
map("t", "<C-k>", [[<cmd>wincmd k<cr>]], { desc = "Go to Upper Window" })
map("t", "<C-l>", [[<cmd>wincmd l<cr>]], { desc = "Go to Right Window" })
map("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Normal Mode Window" })
