pcall(function()
  -- experimental loader
  vim.loader.enable()
end)

-- main config table
_G.Config = {
  path_package = vim.fn.stdpath("data") .. "/site/",
  path_source = vim.fn.stdpath("config") .. "/src/",
  path_snapshot = vim.fn.stdpath("config") .. "/snapshot",
}

-- bootstrap `mini.nvim`
local mini_path = Config.path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd([[echo "Installing 'mini.nvim'" | redraw]])
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd([[packadd mini.nvim | helptags ALL]])
  vim.cmd([[echo "Installed 'mini.nvim'" | redraw]])
end

local deps = require("mini.deps")
deps.setup({
  path = {
    package = Config.path_package,
    snapshot = Config.path_snapshot,
  },
})

local add, now, later = deps.add, deps.now, deps.later

local source = function(path)
  dofile(Config.path_source .. path)
end

  -- settings and mappings
  -- stylua: ignore start
now(function() source("options.lua") end)
now(function() require("hosaka").setup() end)
now(function() source("autocmds.lua") end)
now(function() source("keymaps.lua") end)
now(function() source("leadermaps.lua") end)
if vim.g.vscode then now(function() source("vscode.lua") end) end
if vim.g.neovide then now(function() source("neovide.lua") end) end
-- stylua: ignore end

add({ name = "mini.nvim", checkout = "main" })

-- immediate config
now(function()
  source("plugins/mini.notify.lua")
end)

now(function()
  require("mini.sessions").setup()
end)

now(function()
  local starter = require("mini.starter")
  starter.setup({
    items = {
      starter.sections.sessions(),
      starter.sections.recent_files(5, false, false),
      starter.sections.pick(),
      starter.sections.builtin_actions(),
    },
    footer = "",
  })
end)

now(function()
  require("mini.statusline").setup()
end)

now(function()
  require("mini.tabline").setup({
    tabpage_section = "right",
  })
end)

now(function()
  source("plugins/mini.icons.lua")
end)

-- delayed config
later(function()
  require("mini.extra").setup()
end)

later(function()
  source("plugins/mini.ai.lua")
end)

later(function()
  require("mini.align").setup()
end)

later(function()
  require("mini.basics").setup({
    options = {
      -- manage options manually
      basic = false,
    },
    mappings = {
      windows = true,
      option_toggle_prefix = "",
    },
  })
end)

later(function()
  require("mini.bracketed").setup()
end)

later(function()
  require("mini.bufremove").setup()
end)

later(function()
  source("plugins/mini.clue.lua")
end)

later(function()
  require("mini.comment").setup()
end)

-- later(function()
--   local minicomplete = require("mini.completion")
--   minicomplete.setup({
--     lsp_completion = {
--       source_func = "omnifunc",
--       -- omnifunc is set per buffer in LSP on_attach
--       auto_setup = false,
--       process_items = function(items, base)
--         -- don't show Text suggestions
--         items = vim.tbl_filter(function(item)
--           return item.kind ~= 1
--         end, items)
--         return minicomplete.default_process_items(items, base)
--       end,
--     },
--     window = {
--       info = { border = "rounded" },
--       signature = { border = "rounded" },
--     },
--   })
-- end)

later(function()
  require("mini.cursorword").setup()
end)

later(function()
  require("mini.diff").setup({
    view = {
      style = "sign",
    },
  })
end)

later(function()
  source("plugins/mini.files.lua")
end)

later(function()
  require("mini.git").setup()
end)

later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = require("mini.extra").gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  require("mini.indentscope").setup({
    symbol = "│",
    options = {
      try_as_border = true,
    },
  })
end)

later(function()
  require("mini.jump").setup()
end)

later(function()
  require("mini.jump2d").setup({
    view = {
      dim = true,
      n_steps_ahead = 2,
    },
    mappings = {
      start_jumping = "",
    },
  })
  -- disable s shortcut (use cl instead) in order to use mini.jump2d
  vim.keymap.set({ "n", "x", "o" }, "s", [[<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<cr>]])
end)

later(function()
  local minimisc = require("mini.misc")
  minimisc.setup({
    make_global = { "put", "put_text" },
  })
  -- chdir to root directory containing these files
  minimisc.setup_auto_root({ ".git", "Makefile" })
  -- restore cursor position on open files
  minimisc.setup_restore_cursor()
  -- terminal background synchronization
  minimisc.setup_termbg_sync()
end)

later(function()
  require("mini.move").setup()
end)

later(function()
  source("plugins/mini.operators.lua")
end)

later(function()
  -- disabled in options.lua, can be toggled with <Leader>op
  require("mini.pairs").setup({
    modes = {
      insert = true,
      command = false,
      terminal = false,
    },
  })
end)

later(function()
  source("plugins/mini.pick.lua")
end)

later(function()
  source("plugins/mini.surround.lua")
end)

later(function()
  require("mini.trailspace").setup()
end)

later(function()
  source("plugins/mini.visits.lua")
end)

-- dependencies
now(function()
  add("folke/tokyonight.nvim")
  source("plugins/tokyonight.lua")
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
  source("plugins/dressing.lua")
end)

later(function()
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

  source("plugins/nvim-treesitter.lua")
  source("plugins/nvim-treesitter-context.lua")
end)

later(function()
  add({
    source = "williamboman/mason.nvim",
    depends = { "williamboman/mason-lspconfig.nvim" },
  })
  require("mason").setup({
    -- prefer existing binaries over the ones installed by mason
    -- PATH = "append",
    ui = {
      border = "rounded",
    },
  })
end)

later(function()
  add("mfussenegger/nvim-lint")
  source("plugins/nvim-lint.lua")
end)

later(function()
  add("stevearc/conform.nvim")
  source("plugins/conform.lua")
end)

later(function()
  add({
    source = "saghen/blink.cmp",
    checkout = "v0.6.1",
  })
  source("plugins/blink.lua")
end)

later(function()
  add("b0o/SchemaStore.nvim")
end)

later(function()
  add("mrcjkb/rustaceanvim")
end)

later(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
  })
  source("plugins/nvim-lspconfig.lua")
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
  source("plugins/neogit.lua")
end)

later(function()
  add("sindrets/diffview.nvim")
  source("plugins/diffview.lua")
end)

later(function()
  add("akinsho/toggleterm.nvim")
  source("plugins/toggleterm.lua")
end)

later(function()
  add("stevearc/quicker.nvim")
  source("plugins/quicker.lua")
end)

later(function()
  add("kevinhwang91/nvim-bqf")
  source("plugins/nvim-bqf.lua")
end)

later(function()
  add("lukas-reineke/indent-blankline.nvim")
  source("plugins/indent-blankline.lua")
end)

later(function()
  add({
    source = "MeanderingProgrammer/render-markdown.nvim",
    depends = { "nvim-treesitter/nvim-treesitter" },
  })
  source("plugins/render-markdown.lua")
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
        vim.cmd("AvanteBuild source=false")
      end,
    },
  })
  source("plugins/avante.lua")
end)
