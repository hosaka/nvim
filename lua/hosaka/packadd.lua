local packadd = function(plugin)
  vim.cmd(string.format([[%s %s]], "packadd", plugin))
  pcall(require, "hosaka.config." .. plugin)
end

local packadd_defer = function(plugin)
  vim.schedule(function()
    packadd(plugin)
  end)
end

packadd("mini")

packadd("plenary")
packadd("dressing")
packadd("nvim-web-devicons")

packadd_defer("gitsigns")
packadd_defer("diffview")
packadd_defer("neogit")

packadd_defer("mason")
packadd_defer("mason-lspconfig")
packadd_defer("nvim-lspconfig")
packadd_defer("nvim-lint")
packadd_defer("conform")

packadd_defer("luasnip")
packadd_defer("nvim-cmp")
packadd_defer("cmp-buffer")
packadd_defer("cmp-cmdline")
packadd_defer("cmp-nvim-lsp")

packadd_defer("nvim-treesitter")
packadd_defer("nvim-treesitter-context")
packadd_defer("nvim-treesitter-textobjects")

packadd_defer("telescope")
packadd_defer("toggleterm")
packadd_defer("nvim-spectre")
packadd_defer("oil")

local hooks = function()
  -- ensure all help tags are updated
  vim.cmd("helptags ALL")

  -- update treesitter parsers
  vim.cmd("silent TSUpdate")
end

vim.schedule(hooks)
