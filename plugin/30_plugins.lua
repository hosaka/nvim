local add = vim.pack.add
local now, now_if_args, later, on_filetype = Config.now, Config.now_if_args, Config.later, Config.on_filetype

local source = function(path)
  return dofile(vim.fn.stdpath("config") .. "/" .. path)
end

-- package hooks
-- possible callbacks defined in vim.pack.Speck.data: on_install, on_update, on_delete
-- note: for on_install callback the autocommand must be create before any call to vim.pack.add()
-- so we might want to put this in init.lua instead
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Execute plugin callbacks",
  group = Hosaka.augroup("plugin_callbacks"),
  callback = function(event)
    local data = event.data or {}

    ---@type vim.pack.Spec? plugin specification
    local spec = data.spec
    if spec == nil or spec.data == nil then
      return
    end

    ---@type ("install" | "update" | "delete" )
    local kind = data.kind

    -- ---@type boolean whether plugin was added via vim.pack.add() to current session
    -- local active = data.active
    -- if not active then
    --   vim.cmd.packadd(spec.name)
    -- end

    local callback = vim.tbl_get(spec.data, "on_" .. (kind or ""))
    if type(callback) ~= "function" then
      return
    end

    local ok, err = pcall(callback, data)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
})

local gh = function(x)
  return "https://github.com/" .. x
end

-- immediate config ------------------------------------------------------------

now(function()
  add({ gh("folke/tokyonight.nvim") })
  source("config/tokyonight.lua")
end)

-- immediate or delayed config -------------------------------------------------

now_if_args(function()
  add({
    gh("romus204/tree-sitter-manager.nvim"),
    gh("nvim-treesitter/nvim-treesitter-textobjects"),
    gh("nvim-treesitter/nvim-treesitter-context"),
    gh("windwp/nvim-ts-autotag"),
    gh("andymass/vim-matchup"),
  })

  -- matchup desc
  local miniclue = require("mini.clue")
  miniclue.set_mapping_desc("n", "%", "Go to next match")
  miniclue.set_mapping_desc("n", "g%", "Go to previous match")
  miniclue.set_mapping_desc("n", "[%", "Match first")
  miniclue.set_mapping_desc("n", "]%", "Match last")
  miniclue.set_mapping_desc("n", "z%", "Jump inside a match")

  source("config/tree-sitter.lua")
end)

now_if_args(function()
  add({
    gh("neovim/nvim-lspconfig"),
    gh("b0o/SchemaStore.nvim"),
  })
  source("config/nvim-lspconfig.lua")

  -- enable all LSPs
  vim.lsp.enable({
    "bashls",
    "clangd",
    "dockerls",
    "eslint",
    "gopls",
    "jsonls",
    "just",
    "lua_ls",
    "marksman",
    "ruff",
    "rust_analyzer",
    "taplo",
    "tofu_ls",
    "ty",
    "vtsls",
    "yamlls",
    "zls",
  })
end)

now_if_args(function()
  add({ gh("b0o/incline.nvim") })
  source("config/incline.lua")
end)

-- delayed config --------------------------------------------------------------

later(function()
  add({ gh("stevearc/dressing.nvim") })
  source("config/dressing.lua")
end)

later(function()
  add({
    gh("mfussenegger/nvim-dap"),
    gh("rcarriga/nvim-dap-ui"),
    gh("nvim-neotest/nvim-nio"),
  })
  source("config/dap.lua")
end)

later(function()
  add({
    -- fixme: anything above this version will crash neovim, wait till v2 release
    { src = gh("saghen/blink.cmp"), version = "v1.3.1" },
    gh("rafamadriz/friendly-snippets"),
    -- (optional) use treesitter to highlight completion items
    gh("xzbdmw/colorful-menu.nvim"),
  })
  source("config/blink.lua")
end)

later(function()
  add({ gh("mfussenegger/nvim-lint") })
  source("config/nvim-lint.lua")
end)

later(function()
  add({ gh("stevearc/conform.nvim") })
  source("config/conform.lua")
end)

later(function()
  add({ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" })
  require("lsp_lines").setup()
  -- disabled by default, see `nvim-lspconfig.lua` for keymaps
  vim.diagnostic.config({ virtual_lines = false })
end)

later(function()
  add({ gh("sindrets/diffview.nvim") })
  source("config/diffview.lua")
end)

later(function()
  add({ gh("akinsho/toggleterm.nvim") })
  source("config/toggleterm.lua")
end)

later(function()
  add({ gh("stevearc/quicker.nvim") })
  source("config/quicker.lua")
end)

later(function()
  add({ gh("kevinhwang91/nvim-bqf") })
  source("config/nvim-bqf.lua")
end)

later(function()
  add({ gh("lukas-reineke/indent-blankline.nvim") })
  source("config/indent-blankline.lua")
end)

later(function()
  add({
    gh("kevinhwang91/nvim-ufo"),
    gh("kevinhwang91/promise-async"),
  })
  source("config/nvim-ufo.lua")
end)

later(function()
  add({ gh("wakatime/vim-wakatime") })
end)

later(function()
  add({ gh("stevearc/overseer.nvim") })
  source("config/overseer.lua")
end)

-- conditional config ----------------------------------------------------------

on_filetype("markdown", function()
  add({ gh("MeanderingProgrammer/render-markdown.nvim") })
  source("config/render-markdown.lua")
end)

on_filetype("lua", function()
  add({ gh("folke/lazydev.nvim") })
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
