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

-- bootstrap 'mini.nvim'
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
  miniicons.setup({
    -- ignore some extensions and rely on `vim.filetype.match()` fallback
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
  })
  miniicons.mock_nvim_web_devicons()
  -- note: enable if using mini.completion
  -- later(miniicons.tweak_lsp_kind)
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
      Config.leader_group_clues,
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
  -- defaults
  local show_dotfiles = false
  local minifiles = require("mini.files")

  local content_filter = function(fs_entry)
    local show = true
    if not show_dotfiles then
      show = not vim.startswith(fs_entry.name, ".")
    end
    return show
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    minifiles.refresh({
      content = { filter = content_filter },
    })
  end

  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd("belowright " .. direction .. " split")
        return vim.api.nvim_get_current_win()
      end)

      -- setting window as a target keeps mini.files open
      minifiles.set_target_window(new_target)
      minifiles.go_in()
    end

    local desc = "Open in " .. direction .. " split"
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
  end

  local set_cwd = function()
    local cur_entry_path = minifiles.get_fs_entry().path
    local cur_directory = vim.fs.dirname(cur_entry_path)
    if cur_directory ~= nil then
      vim.fn.chdir(cur_directory)
    end
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- adding `desc` will show keymaps in the help popup (g?)
      vim.keymap.set(
        "n",
        "<CR>",
        [[<cmd>lua MiniFiles.go_in({ close_on_file = true})<cr>]],
        { buffer = buf_id, desc = "Open" }
      )
      vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden" })
      vim.keymap.set("n", "gc", set_cwd, { buffer = buf_id, desc = "Set cwd" })
      map_split(buf_id, "<C-s>", "horizontal")
      map_split(buf_id, "<C-v>", "vertical")
    end,
  })

  minifiles.setup({
    content = {
      filter = content_filter,
    },
    windows = {
      preview = true,
      width_focus = 30,
      width_nofocus = 15,
      width_preview = 100,
    },
    options = {
      -- replacing netrw breaks nvim scp://user@host//path/to/file
      use_as_default_explorer = false,
    },
    mappings = {
      go_in = "L",
      go_in_plus = "l",
      go_out = "H",
      go_out_plus = "h",
      synchronize = "s",
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
  local remap = function(mode, lhs_from, lhs_to, desc)
    local keymap = vim.fn.maparg(lhs_from, mode, false, true)
    local rhs = keymap.callback or keymap.rhs
    if rhs == nil then
      error("Could not remap from " .. lhs_from .. " to " .. lhs_to)
    end
    vim.keymap.set(mode, lhs_to, rhs, { desc = desc or keymap.desc })
  end
  -- remap built-in open filepath/URI keymap
  remap("n", "gx", "<Leader>rx", "Open filepath or URI")
  remap("x", "gx", "<Leader>rx", "Open filepath or URI")

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
    mappings = {
      -- choosing marked items will send them to quickfix list
      choose_marked = "<C-q>",
    },
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

  -- same as default buf_lines picker but with treesitter highlight preserved
  local pick_buffer_lines = function(buffer, items, query, opts)
    if items == nil or #items == 0 or not items[1].bufnr then
      return
    end

    minipick.default_show(buffer, items, query, opts)

    local ns = vim.api.nvim_create_namespace("pick_buffer_syntax_highlight")
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

    -- assume all items come from the same buffer
    local bufnr = items[1].bufnr

    local filetype = vim.bo[bufnr].filetype
    local has_lang, lang = pcall(vim.treesitter.language.get_lang, filetype)
    if not has_lang then
      lang = filetype
    end

    -- parse the buffer to get the syntax tree
    local parser = vim.treesitter.get_parser(bufnr, lang)
    if not parser then
      vim.notify("Failed to get Treesitter parser for language: " .. lang, vim.log.levels.ERROR)
      return
    end
    local tree = parser:parse()[1]
    local root = tree:root()

    -- get the highlight query for the language
    local ts_query = vim.treesitter.query.get(lang, "highlights")
    if not ts_query then
      return
    end

    -- build a mapping from original line numbers to picker buffer line indices
    local line_num_to_picker_line = {}
    local prefix_lengths = {}

    local total_lines = vim.api.nvim_buf_line_count(buffer)
    for line = 1, total_lines do
      local display_line = vim.api.nvim_buf_get_lines(buffer, line - 1, line, false)[1] or ""

      -- match the line number prefix added by default_show
      local prefix_pattern = "^(%s*(%d+)%s*│)"
      local prefix_start, prefix_end, prefix, line_str = display_line:find(prefix_pattern)
      local prefix_length = prefix_end or 0
      local line_number = tonumber(line_str)
      if line_number then
        line_num_to_picker_line[line_number - 1] = line - 1
        prefix_lengths[line_number - 1] = prefix_length
      end
    end

    -- determine the range of lines to process
    local min_line, max_line = math.huge, -math.huge
    for line_number, _ in pairs(line_num_to_picker_line) do
      if line_number < min_line then
        min_line = line_number
      end
      if line_number > max_line then
        max_line = line_number
      end
    end

    if min_line == math.huge or max_line == -math.huge then
      return
    end

    local start_line = min_line
    local end_line = max_line + 1 -- end_line is exclusive

    -- todo: exclude the `query` from being highlighted, otherwise can't see the fuzzy matches

    -- iterate over all captures in range
    for id, node in ts_query:iter_captures(root, bufnr, start_line, end_line) do
      local hl = ts_query.captures[id] -- name of the capture
      if hl then
        local sr, sc, er, ec = node:range()

        -- apply highlights for each line the node spans
        for line = sr, er do
          local picker_line = line_num_to_picker_line[line]
          if picker_line then
            local prefix_length = prefix_lengths[line] or 0
            local start_col = (line == sr) and (sc + prefix_length) or prefix_length
            local end_col = (line == er) and (ec + prefix_length) or -1
            vim.api.nvim_buf_add_highlight(buffer, ns, "@" .. hl, picker_line, start_col, end_col)
          end
        end
      end
    end
  end

  minipick.registry.buf_lines_current = function()
    require("mini.extra").pickers.buf_lines(
      { scope = "current", preserve_order = true },
      { source = { show = pick_buffer_lines } }
    )
  end

  vim.keymap.set({ "n", "x" }, ",", [[<cmd>Pick buf_lines_current<cr>]], { nowait = true })

  minipick.registry.projects = function()
    local cwd = vim.fn.expand("~/wa")
    local choose = function(item)
      vim.schedule(function()
        MiniPick.builtin.files(nil, { source = { cwd = item.path } })
      end)
    end
    return require("mini.extraMiniExtra").pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
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
      cmp = true,
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
  add({ source = "williamboman/mason.nvim", depends = { "williamboman/mason-lspconfig.nvim" } })
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
  require("render-markdown").setup({
    render_modes = { "n", "i", "c" },
    file_types = { "markdown", "Avante" },
  })
  Hosaka.toggle.map("om", {
    name = "markdown",
    get = function()
      return require("render-markdown.state").enabled
    end,
    set = function(state)
      if state then
        require("render-markdown").enable()
      else
        require("render-markdown").disable()
      end
    end,
  })
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
  require("avante_lib").load()
  require("avante").setup({
    provider = "openai",
    behaviour = {
      -- see `src/leadermaps.lua` for keymaps
      auto_set_keymaps = false,
    },
  })
end)
