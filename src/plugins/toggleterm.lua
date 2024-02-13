local H = {}

require("toggleterm").setup({
  float_opts = { border = "rounded" },
  on_create = function()
    vim.opt.foldcolumn = "0"
    vim.opt.signcolumn = "no"
  end,
})

local Terminal = require("toggleterm.terminal").Terminal

H.lazygit = Terminal:new({
  cmd = "lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)",
  direction = "float",
  hidden = true,
  on_open = function(term)
    vim.cmd([[startinsert!]])
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
  end,
})
Hosaka.toggle_lazygit = function()
  H.lazygit:toggle()
end

H.python = Terminal:new({ cmd = "python3", hidden = true })
Hosaka.toggle_python = function()
  H.python:toggle()
end

H.node = Terminal:new({ cmd = "node", hidden = true })
Hosaka.toggle_node = function()
  H.node:toggle()
end
