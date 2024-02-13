require("toggleterm").setup({
  float_opts = { border = "single" },
  on_create = function()
    vim.opt.foldcolumn = "0"
    vim.opt.signcolumn = "no"
  end,
})
