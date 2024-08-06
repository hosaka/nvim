pcall(function()
  -- experimental loader
  vim.loader.enable()
end)

-- main config table
_G.Hosaka = {
  path_package = vim.fn.stdpath("data") .. "/site/",
  path_source = vim.fn.stdpath("config") .. "/src/",
  path_snapshot = vim.fn.stdpath("config") .. "/snapshot",
}

-- bootstrap 'mini.nvim'
local mini_path = Hosaka.path_package .. "pack/deps/start/mini.nvim"
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
    package = Hosaka.path_package,
    snapshot = Hosaka.path_snapshot,
  },
})

local add, now, later = deps.add, deps.now, deps.later

local source = function(path)
  dofile(Hosaka.path_source .. path)
end

-- settings and mappings
-- stylua: ignore start
now(function() source("options.lua") end)
now(function() source("autocmds.lua") end)
now(function() source("functions.lua") end)
now(function() source("keymaps.lua") end)
now(function() source("leadermaps.lua") end)
if vim.g.vscode then now(function() source("vscode.lua") end) end
if vim.g.neovide then now(function() source("neovide.lua") end) end
-- stylua: ignore end

add({ name = "mini.nvim", checkout = "main" })

-- immediate config
now(function()
  local notify = require("mini.notify")
  local notify_filter = function(notif_arr)
    local lua_ls = function(notif)
      return not (vim.startswith(notif.msg, "lua_ls: Diagnosing") or vim.startswith(notif.msg, "lua_ls: Processing"))
    end
    notif_arr = vim.tbl_filter(lua_ls, notif_arr)
    return notify.default_sort(notif_arr)
  end
  notify.setup({
    content = {
      format = function(notif)
        return notif.msg
      end,
      sort = notify_filter,
    },
    window = {
      config = {
        border = "rounded",
      },
    },
  })
  vim.notify = notify.make_notify()
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
  local miniicons = require("mini.icons")
  miniicons.setup()
  miniicons.mock_nvim_web_devicons()
end)

-- delayed config
later(function()
  require("mini.extra").setup()
end)

later(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      m = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
    },
  })
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
      -- option_toggle_prefix = "<leader>o",

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
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = {
      config = {
        width = "auto",
        border = "rounded",
      },
      scroll_down = "<c-n>",
      scroll_up = "<c-p>",
    },
    triggers = {
      -- leader
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },
      -- built-in
      { mode = "i", keys = "<c-x>" },
      -- goto
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      -- marks
      { mode = "n", keys = "'" },
      { mode = "x", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "`" },
      -- nav
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
      -- registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<c-r>" },
      { mode = "c", keys = "<c-r>" },
      -- window
      { mode = "n", keys = "<c-w>" },
      -- z key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
    clues = {
      Hosaka.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({
        submode_move = true,
        submode_resize = true,
      }),
      miniclue.gen_clues.z(),
    },
  })
end)

later(function()
  require("mini.comment").setup()
end)

later(function()
  -- local minicomplete = require("mini.completion")
  -- minicomplete.setup({
  --   -- lsp_completion = {
  --   --   source_func = "omnifunc",
  --   -- },
  --   window = {
  --     info = { border = "single" },
  --     signature = { border = "single" },
  --   },
  -- })
end)

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
  -- defaults
  local show_dotfiles = false

  local content_filter = function(fs_entry)
    local show = true
    if not show_dotfiles then
      show = not vim.startswith(fs_entry.name, ".")
    end
    return show
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    MiniFiles.refresh({
      content = { filter = content_filter },
    })
  end

  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      local new_target_window
      vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
        vim.cmd("belowright " .. direction)
        new_target_window = vim.api.nvim_get_current_win()
      end)

      -- setting window as a target keeps mini.files open
      MiniFiles.set_target_window(new_target_window)
    end

    local desc = "Open in " .. direction
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- adding `desc` will show keymaps in the help popup (g.)
      vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden" })
      map_split(buf_id, "<C-s>", "split")
      map_split(buf_id, "<C-v>", "vsplit")
      vim.keymap.set(
        "n",
        "<CR>",
        [[<cmd>lua MiniFiles.go_in({ close_on_file = true})<cr>]],
        { buffer = buf_id, desc = "Open" }
      )
    end,
  })

  require("mini.files").setup({
    content = {
      filter = content_filter,
    },
    windows = {
      preview = true,
      width_preview = 50,
    },
    options = {
      -- replacing netrw breaks nvim scp://user@host//path/to/file
      -- use_as_default_explorer = false,
    },
    mappings = {
      go_in = "L",
      go_in_plus = "l",
    },
  })
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
  minimisc.setup_auto_root()
  minimisc.setup_restore_cursor()
end)

later(function()
  require("mini.move").setup()
end)

later(function()
  require("mini.operators").setup()
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
  local minipick = require("mini.pick")
  minipick.setup({
    window = {
      config = function()
        -- centered on screen
        local height = math.floor(0.618 * vim.o.lines)
        local width = math.floor(0.618 * vim.o.columns)
        return {
          anchor = "NW",
          border = "rounded",
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end,
    },
  })
  -- use as a default selector
  vim.ui.select = minipick.ui_select
  vim.keymap.set({ "n", "x" }, ",", [[<cmd>Pick buf_lines scope='current'<cr>]], { nowait = true })
end)

later(function()
  require("mini.surround").setup({
    search_method = "cover_or_next",
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsf",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
end)

later(function()
  require("mini.trailspace").setup()
end)

later(function()
  require("mini.visits").setup()
end)

-- dependencies
now(function()
  add("folke/tokyonight.nvim")
  source("plugins/tokyonight.lua")
  vim.cmd([[colorscheme tokyonight-moon]])
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

  source("plugins/nvim-treesitter.lua")
  source("plugins/nvim-treesitter-context.lua")
end)

later(function()
  add({ source = "williamboman/mason.nvim", depens = { "williamboman/mason-lspconfig.nvim" } })
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
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  })
  source("plugins/nvim-cmp.lua")
end)

later(function()
  add("b0o/SchemaStore.nvim")
end)

later(function()
  add("mrcjkb/rustaceanvim")
end)

later(function()
  add({ source = "neovim/nvim-lspconfig", depends = { "williamboman/mason-lspconfig.nvim" } })
  source("plugins/nvim-lspconfig.lua")
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
  add("kevinhwang91/nvim-bqf")
  source("plugins/nvim-bqf.lua")
end)

later(function()
  add("lukas-reineke/indent-blankline.nvim")
  source("plugins/indent-blankline.lua")
end)
