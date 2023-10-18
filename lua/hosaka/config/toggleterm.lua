require("toggleterm").setup({
  direction = "float",
  float_opts = { border = "none" },
  on_create = function()
    vim.opt.foldcolumn = "0"
    vim.opt.signcolumn = "no"
  end,
})
