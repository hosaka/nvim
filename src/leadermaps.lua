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
local mapl = Hosaka.nmap_leader
local xmap_leader = Hosaka.xmap_leader

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
mapl("aa", "[[<cmd>AvanteAsk<cr>]]", "Avante: Ask")
mapl("ad", "[[<cmd>AvanteToggleDebug<cr>]]", "Avante: Debug toggle")
mapl("ah", "[[<cmd>AvanteToggleHint<cr>]]", "Avante: Hint toggle")
mapl("ar", "[[<cmd>AvanteRefresh<cr>]]", "Avante: Refresh")
xmap_leader("aa", "[[<cmd>AvanteAsk<cr>]]", "Avante: Ask")
xmap_leader("ae", "[[<cmd>AvanteEdit<cr>]]", "Avante: Edit")

-- b is for buffer
mapl("bb", [[<cmd>b#<cr>]], "Other")
mapl("bn", [[<cmd>bnext<cr>]], "Next")
mapl("bp", [[<cmd>bprevious<cr>]], "Prev")
mapl("bs", [[<cmd>lua Hosaka.new_scratch_buffer()<cr>]], "Scratch")
mapl("bd", [[<cmd>lua require("mini.bufremove").delete()<cr>]], "Delete")
mapl("bD", [[<cmd>lua require("mini.bufremove").delete(0, true)<cr>]], "Delete!")
mapl("bw", [[<cmd>lua require("mini.bufremove").wipeout()<cr>]], "Wipeout")
mapl("bW", [[<cmd>lua require("mini.bufremove").wipeout(0, true)<cr>]], "Wipeout!")

-- c is for code
-- also see `plugins/nvim-lspconfig.lua` for LSP and language specific keymaps
mapl("cl", [[<cmd>lua require("quicker").toggle({ loclist=true })<cr>]], "Toggle loclist")
mapl("cq", [[<cmd>lua require("quicker").toggle()<cr>]], "Toggle quickfix")

-- e is for edit
mapl("en", [[<cmd>enew<cr>]], "New file")
mapl("ed", [[<cmd>lua MiniFiles.open()<cr>]], "Directory")
mapl("ec", [[<cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<cr>]], "Config")
mapl("ef", [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>]], "File directory")
mapl("es", [[<cmd>lua MiniSessions.select()<cr>]], "Select session")
mapl("ew", function()
  vim.ui.input({ prompt = "Session name" }, function(input)
    if input then
      require("mini.sessions").write(input)
    end
  end)
end, "Write session")

-- f is for find
mapl("<Space>", [[<cmd>Pick files<cr>]], "Files")
mapl(",", [[<cmd>Pick open_buffers<cr>]], "Open buffers")
mapl("?", [[<cmd>Pick oldfiles<cr>]], "Recent files")
mapl("f/", [[<cmd>Pick history scope="/"<cr>]], "/ history")
mapl("f:", [[<cmd>Pick history scope=":"<cr>]], ": history")
mapl("fa", [[<cmd>Pick git_hunks scope='staged'<cr>]], "Added hunks (all)")
mapl("fA", [[<cmd>Pick git_hunks path='%' scope='staged'<cr>]], "Added hunks (current)")
mapl("fb", [[<cmd> Pick open_buffers<cr>]], "Open buffers")
mapl("fB", [[<cmd>Pick git_branches<cr>]], "Git branches")
mapl("fc", [[<cmd>Pick git_commits<cr>]], "Commits (all)")
mapl("fC", [[<cmd>Pick git_commits path="%"<cr>]], "Commits (current)")
mapl("fd", [[<cmd>Pick diagnostic scope="all"<cr>]], "Diagnostic (all)")
mapl("fD", [[<cmd>Pick diagnostic scope="current"<cr>]], "Diagnostic (current)")
mapl("ff", [[<cmd>Pick files<cr>]], "Files")
mapl("fF", [[<cmd>Pick git_files<cr>]], "Git files")
mapl("fg", [[<cmd>Pick grep_live<cr>]], "Grep live")
mapl("fw", [[<cmd>Pick grep pattern="<cword>"<cr>]], "Grep current word")
mapl("fW", [[<cmd>Pick grep pattern="<cWORD>"<cr>]], "Grep current WORD")
mapl("fh", [[<cmd>Pick help<cr>]], "Help")
mapl("fH", [[<cmd>Pick hl_groups<cr>]], "Highlight groups")
mapl("fl", [[<cmd>Pick buf_lines scope='all'<cr>]], "Lines (all)")
mapl("fL", [[<cmd>Pick buf_lines_current<cr>]], "Lines (current)")
mapl("fm", [[<cmd>Pick git_hunks<cr>]], "Modified hunks (all)")
mapl("fM", [[<cmd>Pick git_hunks path='%'<cr>]], "Modified hunks (current)")
mapl("fk", [[<cmd>Pick keymaps<cr>]], "Keymaps")
mapl("fo", [[<cmd>Pick options<cr>]], "Options")
mapl("fr", [[<cmd>Pick resume<cr>]], "Resume")
mapl("fp", [[<cmd>Pick projects<cr>]], "Projects")
mapl("fz", [[<cmd>Pick spellsuggest<cr>]], "Spelling suggestions")
mapl("fR", [[<cmd>Pick lsp scope='references'<cr>]], "References (LSP)")
mapl("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], "Symbol workspace (LSP)")
mapl("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], "Symbol buffer (LSP)")

-- g is for git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ |\ \%s --topo-order]]
mapl("gg", [[<cmd>lua Hosaka.toggle_lazygit()<cr>]], "Lazygit")
mapl("gG", [[<cmd>lua require('neogit').open()<cr>]], "Neogit")
mapl("gd", [[<cmd>DiffviewOpen<cr>]], "Diffview")
-- nmap_leader("ga", [[<cmd>Git diff --cached<cr>]], "Added diff")
-- nmap_leader("gA", [[<cmd>Git diff --cached -- %<cr>]], "Added diff buffer")
-- nmap_leader("gd", [[<cmd>Git diff<cr>]], "Diff")
-- nmap_leader("gD", [[<cmd>Git diff -- %<cr>]], "Diff buffer")
mapl("gl", "<cmd>" .. git_log_cmd .. "<cr>", "Log")
mapl("gL", "<cmd>" .. git_log_cmd .. " --follow -- %<cr>", "Log buffer")
mapl("gc", [[<cmd>Git commit<cr>]], "Commit")
mapl("gC", [[<cmd>Git commit --amend<cr>]], "Commit amend")
mapl("go", [[<cmd>lua MiniDiff.toggle_overlay()<cr>]], "Overlay diff")
mapl("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], "Show at cursor")
xmap_leader("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], "Show at selection")
mapl("gQ", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "current" }))
  require("quicker").open()
end, "Hunk quickfix")
mapl("gq", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "all" }))
  require("quicker").open()
end, "Hunk quickfix (all)")

-- o is for options
-- also see `plugins/nvim-lspconfig.lua`
-- also see `plugins/nvim-treesitter-context.lua`
local toggle = require("hosaka.toggle")
local option = toggle.option
local global = toggle.global

global("autoformat_disable", { name = "autoformat" }):mapl("of")
global("minipairs_disable", { name = "autopairs" }):mapl("op")
global("minitrailspace_disable", { name = "trailspace" }):mapl("oT")
option("cursorcolumn", { name = "'cursorcolumn'" }):mapl("oC")
option("cursorline", { name = "'cursorline'" }):mapl("oc")
option("number", { name = "'number'" }):mapl("on")
option("relativenumber", { name = "'relativenumber'" }):mapl("or")
option("spell", { name = "'spell'" }):mapl("os")
option("wrap", { name = "'wrap'" }):mapl("ow")
option("bg", { name = "'background'", on = "dark", off = "light" }):mapl("ob")
mapl("oz", [[<cmd>lua MiniMisc.zoom()<cr>]], "Toggle zoom")

-- q is for quit
mapl("qq", [[<cmd>quitall<cr>]], "Quit all")
mapl("qQ", [[<cmd>quitall!<cr>]], "Quit all!")
mapl("qs", [[<cmd>suspend<cr>]], "Suspend")

-- r is for run
-- also see `plugins/nvim-lspconfig.lua`
mapl("rc", function()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  if vim.loop.fs_stat(config_path) then
    vim.cmd("source" .. config_path)
  end
end, "Config reload")
mapl("rd", [[<cmd>DepsUpdate<cr>]], "Deps update")
mapl("rD", [[<cmd>DepsSnapSave<cr>]], "Deps snapshot")

-- t is for terminal
mapl("tt", [[<cmd>ToggleTerm<cr>]], "Terminal toggle")
mapl("tf", [[<cmd>ToggleTerm direction=float<cr>]], "Terminal float")
mapl("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Terminal horizontal")
mapl("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], "Terminal vertical")
mapl("ts", [[<cmd>TermSelect<cr>]], "Terminal select")
mapl("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], "Terminal send line")
xmap_leader("tl", [[<cmd>ToggleTermSendVisualSelection<cr><esc>]], "Terminal send selection")
mapl("tp", [[<cmd>lua Hosaka.toggle_python()<cr>]], "Python REPL")
mapl("tn", [[<cmd>lua Hosaka.toggle_node()<cr>]], "Node REPL")

-- v is for visits
mapl("vp", [[<cmd>Pick visit_paths cwd=''<cr>]], "Path visits (all)")
mapl("vP", [[<cmd>Pick visit_paths<cr>]], "Path visits (cwd)")
mapl("vv", [[<cmd>lua MiniVisits.add_label("core")<cr>]], "Add core label")
mapl("vV", [[<cmd>lua MiniVisits.remove_label("core")<cr>]], "Remove core label")
mapl("va", function()
  vim.ui.input({ prompt = "Add label" }, function(input)
    if input then
      require("mini.visits").add_label(input)
    end
  end)
end, "Add label")
mapl("vr", function()
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

mapl("vc", pick_visits("core", ""), "Core visits (all)")
mapl("vC", pick_visits("core", nil), "Core visits (cwd)")
nmap("]]", iterate_visits("core", "forward"), "Core forward")
nmap("[[", iterate_visits("core", "backward"), "Core backward")
