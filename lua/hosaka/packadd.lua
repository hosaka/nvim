-- Source plugin and its configuration immediately
-- @param plugin String with name of plugin as subdirectory in 'pack'
local packadd = function(plugin)
  -- Add plugin. Using `packadd!` during startup is better for initialization
  -- order (see `:h load-plugins`). Use `packadd` otherwise to also force
  -- 'plugin' scripts to be executed right away.
  -- local command = vim.v.vim_did_enter == 1 and 'packadd' or 'packadd!'
  local command = "packadd"
  vim.cmd(string.format([[%s %s]], command, plugin))

  -- Try execute its configuration
  pcall(require, "hosaka.config." .. plugin)
end

-- Defer plugin source right after Vim is loaded
--
-- This reduces time before a fully functional start screen is shown. Use this
-- for plugins that are not directly related to startup process.
--
-- @param plugin String with name of plugin as subdirectory in 'pack/plugins/opt/'
local packadd_later = function(plugin)
  hosaka.later(function()
    packadd(plugin)
  end)
end

hosaka.now(function()
  packadd("mini")
end)

packadd("nvim-web-devicons")
packadd_later("tokyonight")
packadd_later("dressing")

packadd("nvim-cmp")
packadd("luasnip")
packadd("cmp-luasnip")
packadd("cmp-nvim-lsp")
packadd("cmp-nvim-lsp-signature-help")
packadd("cmp-buffer")
packadd("cmp-cmdline")

packadd_later("rustaceanvim")
packadd_later("schemastore")

packadd_later("mason")
packadd_later("mason-lspconfig")
packadd_later("nvim-lspconfig")
packadd_later("nvim-lint")
packadd_later("conform")

packadd_later("nvim-treesitter")
packadd_later("nvim-treesitter-context")
packadd_later("nvim-treesitter-textobjects")
packadd_later("nvim-ts-autotag")

packadd_later("plenary")
packadd_later("gitsigns")
packadd_later("diffview")
packadd_later("neogit")
packadd_later("toggleterm")
packadd_later("indent-blankline")
packadd_later("oatmeal")

local hooks = function()
  -- set the colorscheme
  vim.cmd([[colorscheme tokyonight-moon]])

  -- ensure all help tags are updated
  vim.cmd([[helptags ALL]])

  -- update treesitter parsers
  vim.cmd([[silent TSUpdate]])
end

hosaka.later(hooks)
