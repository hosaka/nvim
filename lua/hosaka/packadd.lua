local load = hosaka.load
local lazy = hosaka.lazy

load("mini")

load("plenary")
load("nvim-web-devicons")

lazy("dressing")
lazy("gitsigns")
lazy("diffview")
lazy("neogit")

load("nvim-cmp")
load("luasnip")
load("cmp-luasnip")
load("cmp-nvim-lsp")
load("cmp-nvim-lsp-signature-help")
load("cmp-buffer")
load("cmp-cmdline")

lazy("mason")
lazy("mason-lspconfig")
lazy("nvim-lspconfig")
lazy("nvim-lint")
lazy("conform")

lazy("nvim-treesitter")
lazy("nvim-treesitter-context")

lazy("toggleterm")
lazy("nvim-spectre")
lazy("oil")

local hooks = function()
  -- ensure all help tags are updated
  vim.cmd("helptags ALL")

  -- update treesitter parsers
  vim.cmd("silent TSUpdate")
end

vim.schedule(hooks)
