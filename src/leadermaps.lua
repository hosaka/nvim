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

local mapl = Hosaka.keymap.mapl

-- registers
mapl("p", [["_dP]], { mode = "x", desc = "Paste to blackhole" })
mapl("d", [["_d]], { mode = "x", desc = "Delete to blackhole" })

-- tabs
-- mapl("n", "<Tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- mapl("n", "<Tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- mapl("n", "<Tab><Tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- mapl("n", "<Tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- mapl("n", "<Tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
-- mapl("n", "<Tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- a is for assist
mapl("aa", "[[<cmd>AvanteAsk<cr>]]", { mode = { "n", "x" }, desc = "Avante: Ask" })
mapl("ad", "[[<cmd>AvanteToggleDebug<cr>]]", { desc = "Avante: Debug toggle" })
mapl("ah", "[[<cmd>AvanteToggleHint<cr>]]", { desc = "Avante: Hint toggle" })
mapl("ar", "[[<cmd>AvanteRefresh<cr>]]", { desc = "Avante: Refresh" })
mapl("ae", "[[<cmd>AvanteEdit<cr>]]", { mode = "x", desc = "Avante: Edit" })

-- b is for buffer
mapl("bb", [[<cmd>b#<cr>]], { desc = "Other" })
mapl("bn", [[<cmd>bnext<cr>]], { desc = "Next" })
mapl("bp", [[<cmd>bprevious<cr>]], { desc = "Prev" })
mapl("bs", [[<cmd>lua Hosaka.new_scratch_buffer()<cr>]], { desc = "Scratch" })
mapl("bd", [[<cmd>lua require("mini.bufremove").delete()<cr>]], { desc = "Delete" })
mapl("bD", [[<cmd>lua require("mini.bufremove").delete(0, true)<cr>]], { desc = "Delete!" })
mapl("bw", [[<cmd>lua require("mini.bufremove").wipeout()<cr>]], { desc = "Wipeout" })
mapl("bW", [[<cmd>lua require("mini.bufremove").wipeout(0, true)<cr>]], { desc = "Wipeout!" })

-- c is for code
-- also see `plugins/nvim-lspconfig.lua` for LSP and language specific keymaps
mapl("cl", [[<cmd>lua require("quicker").toggle({ loclist=true })<cr>]], { desc = "Toggle loclist" })
mapl("cq", [[<cmd>lua require("quicker").toggle()<cr>]], { desc = "Toggle quickfix" })

-- e is for edit
mapl("en", [[<cmd>enew<cr>]], { desc = "New file" })
mapl("ed", [[<cmd>lua MiniFiles.open()<cr>]], { desc = "Directory" })
mapl("ec", [[<cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<cr>]], { desc = "Config" })
mapl("ef", [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>]], { desc = "File directory" })
mapl("es", [[<cmd>lua MiniSessions.select()<cr>]], { desc = "Select session" })
mapl("ew", function()
  vim.ui.input({ prompt = "Session name" }, function(input)
    if input then
      require("mini.sessions").write(input)
    end
  end)
end, { desc = "Write session" })

-- f is for find
mapl("<Space>", [[<cmd>Pick files<cr>]], { desc = "Files" })
mapl(",", [[<cmd>Pick open_buffers<cr>]], { desc = "Open buffers" })
mapl("?", [[<cmd>Pick oldfiles<cr>]], { desc = "Recent files" })
mapl("f/", [[<cmd>Pick history scope="/"<cr>]], { desc = "/ history" })
mapl("f:", [[<cmd>Pick history scope=":"<cr>]], { desc = ": history" })
mapl("fa", [[<cmd>Pick git_hunks scope='staged'<cr>]], { desc = "Added hunks (all)" })
mapl("fA", [[<cmd>Pick git_hunks path='%' scope='staged'<cr>]], { desc = "Added hunks (current)" })
mapl("fb", [[<cmd> Pick open_buffers<cr>]], { desc = "Open buffers" })
mapl("fB", [[<cmd>Pick git_branches<cr>]], { desc = "Git branches" })
mapl("fc", [[<cmd>Pick git_commits<cr>]], { desc = "Commits (all)" })
mapl("fC", [[<cmd>Pick git_commits path="%"<cr>]], { desc = "Commits (current)" })
mapl("fd", [[<cmd>Pick diagnostic scope="all"<cr>]], { desc = "Diagnostic (all)" })
mapl("fD", [[<cmd>Pick diagnostic scope="current"<cr>]], { desc = "Diagnostic (current)" })
mapl("ff", [[<cmd>Pick files<cr>]], { desc = "Files" })
mapl("fF", [[<cmd>Pick git_files<cr>]], { desc = "Git files" })
mapl("fg", [[<cmd>Pick grep_live<cr>]], { desc = "Grep live" })
mapl("fw", [[<cmd>Pick grep pattern="<cword>"<cr>]], { desc = "Grep current word" })
mapl("fW", [[<cmd>Pick grep pattern="<cWORD>"<cr>]], { desc = "Grep current WORD" })
mapl("fh", [[<cmd>Pick help<cr>]], { desc = "Help" })
mapl("fH", [[<cmd>Pick hl_groups<cr>]], { desc = "Highlight groups" })
mapl("fl", [[<cmd>Pick buf_lines scope='all'<cr>]], { desc = "Lines (all)" })
mapl("fL", [[<cmd>Pick buf_lines_current<cr>]], { desc = "Lines (current)" })
mapl("fm", [[<cmd>Pick git_hunks<cr>]], { desc = "Modified hunks (all)" })
mapl("fM", [[<cmd>Pick git_hunks path='%'<cr>]], { desc = "Modified hunks (current)" })
mapl("fk", [[<cmd>Pick keymaps<cr>]], { desc = "Keymaps" })
mapl("fo", [[<cmd>Pick options<cr>]], { desc = "Options" })
mapl("fr", [[<cmd>Pick resume<cr>]], { desc = "Resume" })
mapl("fp", [[<cmd>Pick projects<cr>]], { desc = "Projects" })
mapl("fz", [[<cmd>Pick spellsuggest<cr>]], { desc = "Spelling suggestions" })
mapl("fR", [[<cmd>Pick lsp scope='references'<cr>]], { desc = "References (LSP)" })
mapl("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], { desc = "Symbol workspace (LSP)" })
mapl("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], { desc = "Symbol buffer (LSP)" })

-- g is for git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ |\ \%s --topo-order]]
mapl("gg", [[<cmd>lua Hosaka.toggle_lazygit()<cr>]], { desc = "Lazygit" })
mapl("gG", [[<cmd>lua require('neogit').open()<cr>]], { desc = "Neogit" })
mapl("gd", [[<cmd>DiffviewOpen<cr>]], { desc = "Diffview" })
-- mapl("ga", [[<cmd>Git diff --cached<cr>]], { desc = "Added diff" })
-- mapl("gA", [[<cmd>Git diff --cached -- %<cr>]], { desc = "Added diff buffer" })
-- mapl("gd", [[<cmd>Git diff<cr>]], { desc = "Diff" })
-- mapl("gD", [[<cmd>Git diff -- %<cr>]], { desc = "Diff buffer" })
mapl("gl", "<cmd>" .. git_log_cmd .. "<cr>", { desc = "Log" })
mapl("gL", "<cmd>" .. git_log_cmd .. " --follow -- %<cr>", { desc = "Log buffer" })
mapl("gc", [[<cmd>Git commit<cr>]], { desc = "Commit" })
mapl("gC", [[<cmd>Git commit --amend<cr>]], { desc = "Commit amend" })
mapl("go", [[<cmd>lua MiniDiff.toggle_overlay()<cr>]], { desc = "Overlay diff" })
mapl("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], { desc = "Show at cursor" })
mapl("gs", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], { mode = "x", desc = "Show at selection" })
mapl("gQ", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "current" }))
  require("quicker").open()
end, { desc = "Hunk quickfix" })
mapl("gq", function()
  vim.fn.setqflist(require("mini.diff").export("qf", { scope = "all" }))
  require("quicker").open()
end, { desc = "Hunk quickfix (all)" })

-- o is for options
-- also see `plugins/nvim-lspconfig.lua`
-- also see `plugins/nvim-treesitter-context.lua`
local option = Hosaka.toggle.option
local global = Hosaka.toggle.global

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
mapl("oz", [[<cmd>lua MiniMisc.zoom()<cr>]], { desc = "Toggle zoom" })

-- q is for quit
mapl("qq", [[<cmd>quitall<cr>]], { desc = "Quit all" })
mapl("qQ", [[<cmd>quitall!<cr>]], { desc = "Quit all!" })
mapl("qs", [[<cmd>suspend<cr>]], { desc = "Suspend" })

-- r is for run
-- also see `plugins/nvim-lspconfig.lua`
mapl("rc", function()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  if vim.loop.fs_stat(config_path) then
    vim.cmd("source" .. config_path)
  end
end, { desc = "Config reload" })
mapl("rd", [[<cmd>DepsUpdate<cr>]], { desc = "Deps update" })
mapl("rD", [[<cmd>DepsSnapSave<cr>]], { desc = "Deps snapshot" })

-- t is for terminal
mapl("tt", [[<cmd>ToggleTerm<cr>]], { desc = "Terminal toggle" })
mapl("tf", [[<cmd>ToggleTerm direction=float<cr>]], { desc = "Terminal float" })
mapl("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], { desc = "Terminal horizontal" })
mapl("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], { desc = "Terminal vertical" })
mapl("ts", [[<cmd>TermSelect<cr>]], { desc = "Terminal select" })
mapl("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], { desc = "Terminal send line" })
mapl("tl", [[<cmd>ToggleTermSendVisualSelection<cr><esc>]], { mode = "x", desc = "Terminal send selection" })
mapl("tp", [[<cmd>lua Hosaka.toggle_python()<cr>]], { desc = "Python REPL" })
mapl("tn", [[<cmd>lua Hosaka.toggle_node()<cr>]], { desc = "Node REPL" })

-- v is for visits
mapl("vp", [[<cmd>Pick visit_paths cwd=''<cr>]], { desc = "Path visits (all)" })
mapl("vP", [[<cmd>Pick visit_paths<cr>]], { desc = "Path visits (cwd)" })
mapl("vv", [[<cmd>lua MiniVisits.add_label("core")<cr>]], { desc = "Add core label" })
mapl("vV", [[<cmd>lua MiniVisits.remove_label("core")<cr>]], { desc = "Remove core label" })
mapl("va", function()
  vim.ui.input({ prompt = "Add label" }, function(input)
    if input then
      require("mini.visits").add_label(input)
    end
  end)
end, { desc = "Add label" })
mapl("vr", function()
  -- todo: use mini.pick populated from mini.visits.list_labels
  -- to only list labels applicable to the current buffer, remove
  -- upon selecting one
  vim.ui.input({ prompt = "Remove label" }, function(input)
    if input then
      require("mini.visits").remove_label(input)
    end
  end)
end, { desc = "Remove label" })

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

mapl("vc", pick_visits("core", ""), { desc = "Core visits (all)" })
mapl("vC", pick_visits("core", nil), { desc = "Core visits (cwd)" })

local map = Hosaka.keymap.map
map("]]", iterate_visits("core", "forward"), { desc = "Core forward" })
map("[[", iterate_visits("core", "backward"), { desc = "Core backward" })
