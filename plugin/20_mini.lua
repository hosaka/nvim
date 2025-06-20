local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later

local source = function(path)
  return dofile(vim.fn.stdpath("config") .. "/" .. path)
end

-- make mini.nvim part of the deps snapshot
add({ name = "mini.nvim", checkout = "main" })

-- immediate config
now(function()
  require("mini.basics").setup({
    options = {
      -- manage options manually, see `10_options.lua`
      basic = false,
    },
    mappings = {
      basic = true,
      -- C-hjkl to focus, C-arrows to resize
      windows = true,
      option_toggle_prefix = "",
    },
    autocommands = {
      basic = true,
    },
  })
end)

now(function()
  local miniicons = require("mini.icons")
  miniicons.setup({
    -- ignore some extensions and rely on `vim.filetype.match()` fallback
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
  })
  later(miniicons.mock_nvim_web_devicons)
  -- note: enable if using mini.completion
  -- later(miniicons.tweak_lsp_kind)
end)

now(function()
  local notify = require("mini.notify")
  local notify_filter = function(notif_arr)
    local lua_ls = function(notif)
      if not (notif.data.source == "lsp_progress" and notif.data.client_name == "lua_ls") then
        return true
      end
      return notif.msg:find("Diagnosing") == nil and notif.msg:find("semantic tokens") == nil
    end
    return notify.default_sort(vim.tbl_filter(lua_ls, notif_arr))
  end
  local window_config = function()
    local has_statusline = vim.o.laststatus > 0
    local padding = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - padding }
  end
  notify.setup({
    content = {
      format = function(notif)
        return notif.msg
      end,
      sort = notify_filter,
    },
    window = {
      config = window_config,
    },
  })
  vim.notify = notify.make_notify()
end)

now(function()
  require("mini.sessions").setup()
end)

now(function()
  local starter = require("mini.starter")
  local pick = function()
    local pickers = starter.sections.pick()()
    table.insert(pickers, { name = "Sessions", action = "Pick sessions", section = "Pick" })
    table.insert(pickers, { name = "Projects", action = "Pick projects", section = "Pick" })
    table.sort(pickers, function(lhs, rhs)
      return lhs.name < rhs.name
    end)
    return pickers
  end

  starter.setup({
    items = {
      starter.sections.sessions(),
      starter.sections.recent_files(5, false, false),
      pick,
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

-- delayed config
later(function()
  require("mini.extra").setup()
end)

later(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      -- class
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      -- function
      m = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- code block
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
  require("mini.bracketed").setup()
end)

later(function()
  require("mini.bufremove").setup()
end)

later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    clues = {
      Config.mini.clues,
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
    window = {
      config = {
        width = "auto",
      },
      scroll_down = "<c-n>",
      scroll_up = "<c-p>",
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
  source("config/mini.files.lua")
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
  local map = require("mini.map")
  local gen_integration = map.gen_integration
  map.setup({
    symbols = { encode = map.gen_encode_symbols.dot("3x2") },
    integrations = {
      gen_integration.builtin_search(),
      gen_integration.diff(),
      gen_integration.diagnostic(),
    },
  })
  vim.keymap.set({ "n" }, [[<Esc>]], [[:nohlsearch<cr>]], { desc = "Cancel hlsearch", silent = true })
  for _, key in ipairs({ "n", "N", "*" }) do
    vim.keymap.set("n", key, key .. "zv<cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<cr>")
  end
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
  require("mini.move").setup({
    mappings = {
      left = "",
      right = "",
      down = "<C-M-Down>",
      up = "<C-M-Up>",
    },
  })
end)

later(function()
  local remap = Hosaka.keymap.remap
  -- remap built-in open filepath/URI keymap before setup
  remap("gx", "gX", { desc = "Open filepath or URI" })
  remap("gx", "gX", { mode = "x", desc = "Open filepath or URI" })
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
  source("config/mini.pick.lua")
end)

later(function()
  require("mini.splitjoin").setup()
end)

later(function()
  require("mini.surround").setup({
    mappings = {
      add = "gza",
      delete = "gzd",
      find = "gzf",
      find_left = "gzf",
      highlight = "gzh",
      replace = "gzr",
      update_n_lines = "gzn",
    },
  })
end)

later(function()
  require("mini.trailspace").setup()
end)

later(function()
  source("config/mini.visits.lua")
end)
