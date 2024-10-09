-- global table for mini.clue groups
Config.leader_group_clues = {
  { mode = "n", keys = "<Leader>a", desc = "+Assist" },
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>c", desc = "+Code" },
  { mode = "n", keys = "<Leader>e", desc = "+Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>o", desc = "+Option" },
  { mode = "n", keys = "<Leader>q", desc = "+Quit" },
  { mode = "n", keys = "<Leader>r", desc = "+Run" },
  { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
  { mode = "n", keys = "<Leader>v", desc = "+Visits" },

  { mode = "x", keys = "<Leader>a", desc = "+Assist" },
  { mode = "x", keys = "<Leader>c", desc = "+Code" },
  { mode = "x", keys = "<Leader>g", desc = "+Git" },
  { mode = "x", keys = "<Leader>r", desc = "+Run" },
  { mode = "x", keys = "<Leader>t", desc = "+Terminal" },
}

local nmap = Hosaka.nmap
local nmap_leader = Hosaka.nmap_leader
local xmap_leader = Hosaka.xmap_leader
local nmap_toggle = Hosaka.toggle.map
local nmap_option = Hosaka.toggle.option

-- registers
xmap_leader("p", [["_dP]], "Paste to blackhole")
xmap_leader("d", [["_d]], "Delete to blackhole")

-- tabs
-- map("n", "<Leader><Tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<Leader><Tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<Leader><Tab><Tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<Leader><Tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<Leader><Tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
-- map("n", "<Leader><Tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- a is for assist
nmap_leader("aa", "[[<cmd>AvanteAsk<cr>]]", "Avante: Ask")
nmap_leader("ad", "[[<cmd>AvanteToggleDebug<cr>]]", "Avante: Debug toggle")
nmap_leader("ah", "[[<cmd>AvanteToggleHint<cr>]]", "Avante: Hint toggle")
nmap_leader("ar", "[[<cmd>AvanteRefresh<cr>]]", "Avante: Refresh")
xmap_leader("aa", "[[<cmd>AvanteAsk<cr>]]", "Avante: Ask")
xmap_leader("ae", "[[<cmd>AvanteEdit<cr>]]", "Avante: Edit")

-- b is for buffer
nmap_leader("bb", [[<cmd>b#<cr>]], "Other")
nmap_leader("bn", [[<cmd>bnext<cr>]], "Next")
nmap_leader("bp", [[<cmd>bprevious<cr>]], "Prev")
nmap_leader("bs", [[<cmd>lua Hosaka.new_scratch_buffer()<cr>]], "Scratch")
nmap_leader("bd", [[<cmd>lua require("mini.bufremove").delete()<cr>]], "Delete")
nmap_leader("bD", [[<cmd>lua require("mini.bufremove").delete(0, true)<cr>]], "Delete!")
nmap_leader("bw", [[<cmd>lua require("mini.bufremove").wipeout()<cr>]], "Wipeout")
nmap_leader("bW", [[<cmd>lua require("mini.bufremove").wipeout(0, true)<cr>]], "Wipeout!")

-- c is for code
-- also see `plugins/nvim-lspconfig.lua` for LSP and language specific keymaps
nmap_leader("cl", [[<cmd>lua require("quicker").toggle({ loclist=true })<cr>]], "Toggle loclist")
nmap_leader("cq", [[<cmd>lua require("quicker").toggle()<cr>]], "Toggle quickfix")

-- e is for edit
nmap_leader("en", [[<cmd>enew<cr>]], "New file")
nmap_leader("ed", [[<cmd>lua MiniFiles.open()<cr>]], "Directory")
nmap_leader("ec", [[<cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<cr>]], "Config")
nmap_leader("ef", [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>]], "File directory")
nmap_leader("es", [[<cmd>lua MiniSessions.select()<cr>]], "Select session")
nmap_leader("ew", function()
  vim.ui.input({ prompt = "Session name" }, function(input)
    if input then
      require("mini.sessions").write(input)
    end
  end)
end, "Write session")

local function pick_buffers()
  local minipick = require("mini.pick")
  minipick.builtin.buffers(nil, {
    mappings = {
      delete_buffer = {
        char = "<C-d>",
        func = function()
          local matches = minipick.get_picker_matches()
          if matches then
            if next(matches.marked) then
              for _, buffer in ipairs(matches.marked) do
                vim.cmd.bdelete(buffer.bufnr)
              end
            elseif matches.current then
              -- vim.api.nvim_buf_delete()
              vim.cmd.bdelete(matches.current.bufnr)
            end
            -- fixme: restarting the picker refreshes the items, but perhaps
            -- there's a better way: removing deleted buffers from items
            pick_buffers()
          end
        end,
      },
    },
  })
end

-- f is for find
nmap_leader("<Space>", [[<cmd>Pick files<cr>]], "Files")
nmap_leader(",", pick_buffers, "Open buffers")
nmap_leader("?", [[<cmd>Pick oldfiles<cr>]], "Recent files")
nmap_leader("f/", [[<cmd>Pick history scope="/"<cr>]], "/ history")
nmap_leader("f:", [[<cmd>Pick history scope=":"<cr>]], ": history")
nmap_leader("fa", [[<cmd>Pick git_hunks scope='staged'<cr>]], "Added hunks (all)")
nmap_leader("fA", [[<cmd>Pick git_hunks path='%' scope='staged'<cr>]], "Added hunks (current)")
nmap_leader("fb", pick_buffers, "Open buffers")
nmap_leader("fB", [[<cmd>Pick git_branches<cr>]], "Git branches")
nmap_leader("fc", [[<cmd>Pick git_commits<cr>]], "Commits (all)")
nmap_leader("fC", [[<cmd>Pick git_commits path="%"<cr>]], "Commits (current)")
nmap_leader("fd", [[<cmd>Pick diagnostic scope="all"<cr>]], "Diagnostic (all)")
nmap_leader("fD", [[<cmd>Pick diagnostic scope="current"<cr>]], "Diagnostic (current)")
nmap_leader("ff", [[<cmd>Pick files<cr>]], "Files")
nmap_leader("fF", [[<cmd>Pick git_files<cr>]], "Git files")
nmap_leader("fg", [[<cmd>Pick grep_live<cr>]], "Grep live")
nmap_leader("fw", [[<cmd>Pick grep pattern="<cword>"<cr>]], "Grep current word")
nmap_leader("fW", [[<cmd>Pick grep pattern="<cWORD>"<cr>]], "Grep current WORD")
nmap_leader("fh", [[<cmd>Pick help<cr>]], "Help")
nmap_leader("fH", [[<cmd>Pick hl_groups<cr>]], "Highlight groups")
nmap_leader("fl", [[<cmd>Pick buf_lines scope='all'<cr>]], "Lines (all)")
nmap_leader("fL", [[<cmd>Pick buf_lines_current<cr>]], "Lines (current)")
nmap_leader("fm", [[<cmd>Pick git_hunks<cr>]], "Modified hunks (all)")
nmap_leader("fM", [[<cmd>Pick git_hunks path='%'<cr>]], "Modified hunks (current)")
nmap_leader("fk", [[<cmd>Pick keymaps<cr>]], "Keymaps")
nmap_leader("fo", [[<cmd>Pick options<cr>]], "Options")
nmap_leader("fr", [[<cmd>Pick resume<cr>]], "Resume")
nmap_leader("fp", [[<cmd>Pick spellsuggest<cr>]], "Spelling suggestions")
nmap_leader("fR", [[<cmd>Pick lsp scope='references'<cr>]], "References (LSP)")
nmap_leader("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], "Symbol workspace (LSP)")
nmap_leader("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], "Symbol buffer (LSP)")

-- g is for git
nmap_leader("gg", [[<cmd>lua require('neogit').open()<cr>]], "Neogit")
nmap_leader("gG", [[<cmd>lua Hosaka.toggle_lazygit()<cr>]], "Lazygit")
nmap_leader("gc", [[<cmd>lua require('neogit').open({'commit'})<cr>]], "Commit")
nmap_leader("gd", [[<cmd>DiffviewOpen<cr>]], "Diffview")
nmap_leader("gl", [[<cmd>Git log --oneline<cr>]], "Log")
nmap_leader("gL", [[<cmd>Git log --oneline --follow -- %<cr>]], "Log buffer")
nmap_leader("go", [[<cmd>lua MiniDiff.toggle_overlay()<cr>]], "Overlay diff")
nmap_leader("gQ", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "current" }))
  require("quicker").open()
end, "Hunk quickfix")
nmap_leader("gq", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "all" }))
  require("quicker").open()
end, "Hunk quickfix (all)")
nmap_leader("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], "Show at cursor")
xmap_leader("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], "Show at selection")

-- o is for options
-- also see `plugins/nvim-lspconfig.lua`
-- also see `plugins/nvim-treesitter-context.lua`
nmap_leader("oz", [[<cmd>lua MiniMisc.zoom()<cr>]], "Toggle zoom")
nmap_toggle("od", {
  name = "diagnostics",
  get = function()
    return vim.diagnostic.is_enabled()
  end,
  set = function()
    require("mini.basics").toggle_diagnostic()
  end,
})
nmap_toggle("of", {
  name = "autoformat",
  get = function()
    return not vim.g.autoformat_disable
  end,
  set = function(state)
    vim.g.autoformat_disable = not state
  end,
})
nmap_toggle("op", {
  name = "autopairs",
  get = function()
    return not vim.g.minipairs_disable
  end,
  set = function(state)
    vim.g.minipairs_disable = not state
  end,
})
nmap_toggle("oT", {
  name = "trailspace",
  get = function()
    return not vim.g.minitrailspace_disable
  end,
  set = function(state)
    vim.g.minitrailspace_disable = not state
  end,
})
nmap_option("oC", "cursorcolumn", { name = "'cursorcolumn'" })
nmap_option("oc", "cursorline", { name = "'cursorline'" })
nmap_option("on", "number", { name = "'number'" })
nmap_option("or", "relativenumber", { name = "'relativenumber'" })
nmap_option("os", "spell", { name = "'spell'" })
nmap_option("ow", "wrap", { name = "'wrap'" })
nmap_option("ob", "bg", { name = "background", values = { "dark", "light" }, is_global = true })

-- q is for quit
nmap_leader("qq", [[<cmd>quitall<cr>]], "Quit all")
nmap_leader("qQ", [[<cmd>quitall!<cr>]], "Quit all!")
nmap_leader("qs", [[<cmd>suspend<cr>]], "Suspend")

-- r is for run
-- also see `plugins/nvim-lspconfig.lua`
nmap_leader("rc", function()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  if vim.loop.fs_stat(config_path) then
    vim.cmd("source" .. config_path)
  end
end, "Config reload")
nmap_leader("rd", [[<cmd>DepsUpdate<cr>]], "Deps update")
nmap_leader("rD", [[<cmd>DepsSnapSave<cr>]], "Deps snapshot")

-- t is for terminal
nmap_leader("tt", [[<cmd>ToggleTerm<cr>]], "Terminal toggle")
nmap_leader("tf", [[<cmd>ToggleTerm direction=float<cr>]], "Terminal float")
nmap_leader("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Terminal horizontal")
nmap_leader("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], "Terminal vertical")
nmap_leader("ts", [[<cmd>TermSelect<cr>]], "Terminal select")
nmap_leader("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], "Terminal send line")
xmap_leader("tl", [[<cmd>ToggleTermSendVisualSelection<cr><esc>]], "Terminal send selection")
nmap_leader("tp", [[<cmd>lua Hosaka.toggle_python()<cr>]], "Python REPL")
nmap_leader("tn", [[<cmd>lua Hosaka.toggle_node()<cr>]], "Node REPL")

-- v is for visits
nmap_leader("vp", [[<cmd>Pick visit_paths cwd=''<cr>]], "Path visits (all)")
nmap_leader("vP", [[<cmd>Pick visit_paths<cr>]], "Path visits (cwd)")
nmap_leader("vv", [[<cmd>lua MiniVisits.add_label("core")<cr>]], "Add core label")
nmap_leader("vV", [[<cmd>lua MiniVisits.remove_label("core")<cr>]], "Remove core label")
nmap_leader("va", function()
  vim.ui.input({ prompt = "Add label" }, function(input)
    if input then
      require("mini.visits").add_label(input)
    end
  end)
end, "Add label")
nmap_leader("vr", function()
  -- todo: use mini.pick populated from mini.visits.list_labels
  -- to only list labels applicable to the current buffer, remove
  -- upon selecting one
  vim.ui.input({ prompt = "Remove label" }, function(input)
    if input then
      require("mini.visits").remove_label(input)
    end
  end)
end, "Remove label")

local function pick_visits(label, cwd)
  return function()
    local miniextra = require("mini.extra")
    miniextra.pickers.visit_paths({
      cwd = cwd,
      filter = label,
      recency_weight = 0,
    }, {
      source = { name = string.format("%s visits (%s)", label, cwd ~= "" and "cwd" or "all") },
      mappings = {
        delete_visit = {
          char = "<C-d>",
          func = function()
            local minipick = require("mini.pick")
            local minivisits = require("mini.visits")
            local matches = minipick.get_picker_matches()
            if matches and matches.current then
              minivisits.remove_label(label, matches.current, cwd)
            end
            pick_visits(label, cwd)()
          end,
        },
      },
    })
  end
end

local iterate_visits = function(label, direction)
  return function()
    local minivisits = require("mini.visits")
    minivisits.iterate_paths(direction, vim.fn.getcwd(), { filter = label, recency_weight = 0, wrap = true })
  end
end

nmap_leader("vc", pick_visits("core", ""), "Core visits (all)")
nmap_leader("vC", pick_visits("core", nil), "Core visits (cwd)")
nmap("]]", iterate_visits("core", "forward"), "Core forward")
nmap("[[", iterate_visits("core", "backward"), "Core backward")
