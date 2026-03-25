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

-- immediate config ------------------------------------------------------------

now(function()
  add({ "https://github.com/folke/tokyonight.nvim" })
  source("config/tokyonight.lua")
end)

-- immediate or delayed config -------------------------------------------------

now_if_args(function()
  add({
    {
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
      data = {
        on_update = function()
          vim.cmd([[TSUpdate]])
        end,
      },
    },
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/andymass/vim-matchup",
  })

  -- matchup desc
  local miniclue = require("mini.clue")
  miniclue.set_mapping_desc("n", "%", "Go to next match")
  miniclue.set_mapping_desc("n", "g%", "Go to previous match")
  miniclue.set_mapping_desc("n", "[%", "Match first")
  miniclue.set_mapping_desc("n", "]%", "Match last")
  miniclue.set_mapping_desc("n", "z%", "Jump inside a match")

  source("config/nvim-treesitter.lua")
end)

now_if_args(function()
  -- neovim >= 0.11 introduced vim.lsp.config which we use
  if vim.fn.has("nvim-0.11") == 0 then
    return
  end
  add({ "https://github.com/neovim/nvim-lspconfig" })
  source("config/nvim-lspconfig.lua")
end)

now_if_args(function()
  add({ "https://github.com/b0o/incline.nvim" })
  source("config/incline.lua")
end)

-- delayed config --------------------------------------------------------------

later(function()
  add({ "https://github.com/folke/lazydev.nvim" })
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
  add({ "https://github.com/stevearc/dressing.nvim" })
  source("config/dressing.lua")
end)

later(function()
  add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
  })
  source("config/dap.lua")
end)

later(function()
  add({
    -- fixme: anything above this version will crash neovim, wait till v2 release
    { src = "https://github.com/saghen/blink.cmp", version = "v1.3.1" },
    "https://github.com/rafamadriz/friendly-snippets",
    -- (optional) use treesitter to highlight completion items
    "https://github.com/xzbdmw/colorful-menu.nvim",
  })
  source("config/blink.lua")
end)

later(function()
  add({ "https://github.com/mfussenegger/nvim-lint" })
  source("config/nvim-lint.lua")
end)

later(function()
  add({ "https://github.com/stevearc/conform.nvim" })
  source("config/conform.lua")
end)

later(function()
  add({ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" })
  require("lsp_lines").setup()
  -- disabled by default, see `nvim-lspconfig.lua` for keymaps
  vim.diagnostic.config({ virtual_lines = false })
end)

later(function()
  add({ "https://github.com/sindrets/diffview.nvim" })
  source("config/diffview.lua")
end)

later(function()
  add({ "https://github.com/akinsho/toggleterm.nvim" })
  source("config/toggleterm.lua")
end)

later(function()
  add({ "https://github.com/stevearc/quicker.nvim" })
  source("config/quicker.lua")
end)

later(function()
  add({ "https://github.com/kevinhwang91/nvim-bqf" })
  source("config/nvim-bqf.lua")
end)

later(function()
  add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
  source("config/indent-blankline.lua")
end)

later(function()
  add({
    "https://github.com/kevinhwang91/nvim-ufo",
    "https://github.com/kevinhwang91/promise-async",
  })
  source("config/nvim-ufo.lua")
end)

later(function()
  add({ "https://github.com/wakatime/vim-wakatime" })
end)

later(function()
  add({ "https://github.com/stevearc/overseer.nvim" })
  source("config/overseer.lua")
end)

-- conditional config ----------------------------------------------------------

on_filetype("markdown", function()
  add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
  source("config/render-markdown.lua")
end)
