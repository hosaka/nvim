local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later
local now_if_args = _G.Config.now_if_args

local source = function(path)
  return dofile(vim.fn.stdpath("config") .. "/" .. path)
end

now(function()
  add("folke/tokyonight.nvim")
  source("config/tokyonight.lua")
  vim.cmd([[colorscheme tokyonight]])
end)

later(function()
  add({ source = "folke/lazydev.nvim" })
  require("lazydev").setup({
    library = {
      "nvim-dap-ui",
      -- load luvit types when `vim.uv` or `vim.loop` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
    },
    integrations = {
      lspconfig = true,
    },
  })
end)

later(function()
  add("stevearc/dressing.nvim")
  source("config/dressing.lua")
end)

now_if_args(function()
  local ts_spec = {
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function()
        vim.cmd([[silent TSUpdate]])
      end,
    },
  }
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main", depends = { ts_spec } })
  add({ source = "nvim-treesitter/nvim-treesitter-context", depends = { ts_spec } })
  add({ source = "windwp/nvim-ts-autotag", depends = { ts_spec } })
  add({ source = "andymass/vim-matchup", depends = { ts_spec } })

  -- matchup desc
  local miniclue = require("mini.clue")
  miniclue.set_mapping_desc("n", "%", "Go to next match")
  miniclue.set_mapping_desc("n", "g%", "Go to previous match")
  miniclue.set_mapping_desc("n", "[%", "Match first")
  miniclue.set_mapping_desc("n", "]%", "Match last")
  miniclue.set_mapping_desc("n", "z%", "Jump inside a match")

  source("config/nvim-treesitter.lua")
end)

later(function()
  add("neovim/nvim-lspconfig")
  source("config/nvim-lspconfig.lua")
end)

-- later(function()
--   add({
--     source = "williamboman/mason.nvim",
--     depends = {
--       "williamboman/mason-lspconfig.nvim",
--       "neovim/nvim-lspconfig",
--     },
--   })
--   require("mason").setup({
--     -- prefer existing binaries over the ones installed by mason
--     -- PATH = "append",
--   })
--   require("mason-lspconfig").setup({
--     -- automatic_installation = true,
--     ensure_installed = {
--       "lua_ls",
--       "marksman",
--     },
--   })
--   source("config/nvim-lspconfig.lua")
-- end)

later(function()
  add({
    source = "Bekaboo/dropbar.nvim",
  })
  source("config/dropbar.lua")
end)

later(function()
  add({
    source = "mfussenegger/nvim-dap",
    depends = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  })
  source("config/dap.lua")
end)

later(function()
  add({
    source = "saghen/blink.cmp",
    checkout = "v1.3.1",
    depends = {
      "rafamadriz/friendly-snippets",
      -- (optional) use treesitter to highlight completion items
      "xzbdmw/colorful-menu.nvim",
    },
  })
  source("config/blink.lua")
end)

later(function()
  add("mfussenegger/nvim-lint")
  source("config/nvim-lint.lua")
end)

later(function()
  add("stevearc/conform.nvim")
  source("config/conform.lua")
end)

later(function()
  add({
    source = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    depends = { "neovim/nvim-lspconfig" },
  })
  require("lsp_lines").setup()
  -- disabled by default, see `nvim-lspconfig.lua` for keymaps
  vim.diagnostic.config({ virtual_lines = false })
end)

later(function()
  add("sindrets/diffview.nvim")
  source("config/diffview.lua")
end)

later(function()
  add("akinsho/toggleterm.nvim")
  source("config/toggleterm.lua")
end)

later(function()
  add("stevearc/quicker.nvim")
  source("config/quicker.lua")
end)

later(function()
  add("kevinhwang91/nvim-bqf")
  source("config/nvim-bqf.lua")
end)

later(function()
  add("lukas-reineke/indent-blankline.nvim")
  source("config/indent-blankline.lua")
end)

later(function()
  add({
    source = "MeanderingProgrammer/render-markdown.nvim",
    depends = { "nvim-treesitter/nvim-treesitter" },
  })
  source("config/render-markdown.lua")
end)

later(function()
  add({
    source = "kevinhwang91/nvim-ufo",
    depends = { "kevinhwang91/promise-async" },
  })
  source("config/nvim-ufo.lua")
end)
