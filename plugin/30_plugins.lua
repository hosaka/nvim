local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

local source = function(path)
  return dofile(vim.fn.stdpath("config") .. "/" .. path)
end

now(function()
  add("folke/tokyonight.nvim")
  source("config/tokyonight.lua")
  vim.cmd([[colorscheme tokyonight]])
end)

later(function()
  add({ source = "folke/lazydev.nvim", depends = { "Bilal2453/luvit-meta" } })
  require("lazydev").setup({
    library = {
      -- load luvit types when `vim.uv` or `vim.loop` word is found
      { path = "luvit-meta/library", words = { "vim%.uv", "vim%.loop" } },
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
    hooks = {
      post_checkout = function()
        vim.cmd([[silent TSUpdate]])
      end,
    },
  }
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects", depends = { ts_spec } })
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
  source("config/nvim-treesitter-context.lua")
end)

now_if_args(function()
  add({
    source = "williamboman/mason.nvim",
    depends = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
  })
  require("mason").setup({
    -- prefer existing binaries over the ones installed by mason
    -- PATH = "append",
    ui = {
      border = "rounded",
    },
  })
end)

now_if_args(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "saghen/blink.cmp",
    },
  })
  source("config/nvim-lspconfig.lua")
end)

now_if_args(function()
  add({
    source = "Bekaboo/dropbar.nvim",
  })
  require("dropbar").setup({
    bar = {
      pick = {
        pivots = "hjklasdfqweruiopzxcvm",
      },
    },
    menu = {
      win_configs = {
        border = "rounded",
      },
      entry = {
        padding = {
          left = 0,
          right = 1,
        },
      },
    },
  })
end)

later(function()
  add({
    source = "saghen/blink.cmp",
    checkout = "v0.8.1",
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
  add("b0o/SchemaStore.nvim")
end)

later(function()
  add("mrcjkb/rustaceanvim")
end)

later(function()
  add("rafamadriz/friendly-snippets")
end)

later(function()
  add({
    source = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    depends = { "neovim/nvim-lspconfig" },
  })
  require("lsp_lines").setup()
  -- disabled by default, see `leadermaps.lua` for keymaps
  vim.diagnostic.config({ virtual_lines = false })
end)

later(function()
  add({ source = "NeogitOrg/neogit", depends = { "nvim-lua/plenary.nvim" } })
  source("config/neogit.lua")
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
    source = "yetone/avante.nvim",
    depends = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional
      "MeanderingProgrammer/render-markdown.nvim",
    },
    hooks = {
      post_checkout = function()
        vim.cmd([[make]])
      end,
    },
  })
  source("config/avante.lua")
end)
