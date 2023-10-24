vim.cmd("colorscheme randomhue")

require("mini.sessions").setup({ directory = vim.fn.stdpath("config") .. "/misc/sessions" })

require("mini.starter").setup({
  footer = "",
})

local ministatus = require("mini.statusline")
ministatus.setup({
  content = {
    active = function()
      local mode, mode_hl = ministatus.section_mode({ trunc_width = 120 })
      local spell = vim.wo.spell and (ministatus.is_truncated(120) and "S" or "SPELL") or ""
      local wrap = vim.wo.wrap and (ministatus.is_truncated(120) and "W" or "WRAP") or ""
      local git = ministatus.section_git({ trunc_width = 75 })
      local diagnostics = ministatus.section_diagnostics({ trunc_width = 75 })
      local filename = ministatus.section_filename({ trunc_width = 140 })
      local fileinfo = ministatus.section_fileinfo({ trunc_width = 120 })
      local searchcount = ministatus.section_searchcount({ trunc_width = 75 })
      local location = ministatus.section_location({ trunc_width = 75 })

      return ministatus.combine_groups({
        { hl = mode_hl, strings = { mode, spell, wrap } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
        "%<", -- truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { searchcount, location } },
      })
    end,
  },
})

require("mini.tabline").setup()

vim.schedule(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      O = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      C = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    },
  })

  require("mini.align").setup()

  require("mini.basics").setup({
    options = {
      -- manage options manually
      basic = false,
    },
    mappings = {
      windows = true,
      move_with_alt = true,
      option_toggle_prefix = "<Leader>o",
    },
  })

  require("mini.bracketed").setup()

  require("mini.bufremove").setup()

  local miniclue = require("mini.clue")
  miniclue.setup({
    window = {
      config = {
        width = "auto",
      },
      scroll_down = "<C-n>",
      scroll_up = "<C-p>",
    },
    triggers = {
      -- leader
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      -- built-in
      { mode = "i", keys = "<C-x>" },
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
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      -- window
      { mode = "n", keys = "<C-w>" },
      -- z key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
    clues = {
      hosaka.leader_group_clues,
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

  -- enable clues in help buffers
  local clue_group = vim.api.nvim_create_augroup("hosaka_miniclue", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = clue_group,
    pattern = "help",
    callback = function(event)
      miniclue.enable_buf_triggers(event.buf)
    end,
  })

  require("mini.comment").setup()

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
  --
  require("mini.cursorword").setup()

  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  require("mini.indentscope").setup({
    symbol = "│",
    options = {
      try_as_border = true,
    },
  })

  require("mini.jump2d").setup({
    view = {
      dim = true,
      n_steps_ahead = 2,
    },
    mappings = {
      -- see keymaps.lua
      start_jumping = "",
    },
  })

  local minimisc = require("mini.misc")
  minimisc.setup({
    make_global = { "put", "put_text" },
  })
  minimisc.setup_auto_root()
  minimisc.setup_restore_cursor()

  require("mini.move").setup()

  require("mini.operators").setup()

  require("mini.pairs").setup({
    modes = {
      insert = true,
      command = true,
      terminal = true,
    },
  })

  local minipick = require("mini.pick")
  minipick.setup()
  vim.ui.select = minipick.ui_select
  -- vim.keymap.set("i", ",", [[<cmd>pick buf_lines scope='current'<cr>]], { nowait = true })

  require("mini.surround").setup({
    search_method = "cover_or_next",
  })

  require("mini.trailspace").setup()
end)
