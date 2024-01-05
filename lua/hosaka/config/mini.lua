local now, later = hosaka.now, hosaka.later

-- immediate config
now(function()
  require("mini.sessions").setup({
    autowrite = true,
    directory = vim.fn.stdpath("config") .. "/misc/sessions",
  })
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
      a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      -- html-like tags
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
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
      option_toggle_prefix = "<leader>o",
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
  vim.api.nvim_create_autocmd("filetype", {
    group = clue_group,
    pattern = "help",
    callback = function(event)
      miniclue.enable_buf_triggers(event.buf)
    end,
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
    mappings = {
      go_in = "L",
      go_in_plus = "l",
    },
  })
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
      -- see keymaps.lua
      start_jumping = "",
    },
  })
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
  minipick.setup()
  vim.ui.select = minipick.ui_select
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
