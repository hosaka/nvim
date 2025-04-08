-- basic maps
-- note: a lot of mappings are defined by mini.basics, see `20_mini.lua`

-- paste above/below linewise
vim.keymap.set({ "n", "x" }, "[p", [[<cmd>exe 'put! ' . v:register<cr>]], { desc = "Paste above", silent = true })
vim.keymap.set({ "n", "x" }, "]p", [[<cmd>exe 'put ' . v:register<cr>]], { desc = "Paste below", silent = true })

-- search highlight
vim.keymap.set("n", [[\h]], [[:let v:hlsearch = 1 - v:hlsearch<cr>]], { desc = "Toggle hlsearch", silent = true })
vim.keymap.set({ "i", "n" }, [[<Esc>]], [[<cmd>nohlsearch<cr><esc>]], { desc = "Cancel hlsearch", silent = true })

-- delete empty lines to blackhole
vim.keymap.set("n", "dd", function()
  if vim.fn.getline(".") == "" then
    return '"_dd'
  end
  return "dd"
end, { expr = true })

-- leader maps

-- global table for mini.clue groups
Config.mini.clues = {
  { mode = "n", keys = "<Leader>a", desc = "+Assist" },
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>c", desc = "+Code" },
  { mode = "n", keys = "<Leader>d", desc = "+Debug" },
  { mode = "n", keys = "<Leader>e", desc = "+Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>m", desc = "+Map" },
  { mode = "n", keys = "<Leader>o", desc = "+Option" },
  { mode = "n", keys = "<Leader>q", desc = "+Quit" },
  { mode = "n", keys = "<Leader>r", desc = "+Run" },
  { mode = "n", keys = "<Leader>rd", desc = "+Deps" },
  { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
  { mode = "n", keys = "<Leader>v", desc = "+Visits" },

  { mode = "x", keys = "<Leader>a", desc = "+Assist" },
  { mode = "x", keys = "<Leader>c", desc = "+Code" },
  { mode = "x", keys = "<Leader>g", desc = "+Git" },
  { mode = "x", keys = "<Leader>r", desc = "+Run" },
  { mode = "x", keys = "<Leader>t", desc = "+Terminal" },

  -- see `config/mini.surround.lua`
  { mode = "n", keys = "gz", desc = "Surround" },
  { mode = "x", keys = "gz", desc = "Surround selection" },
}

local map = Hosaka.keymap.map
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

-- b is for buffer
mapl("bb", [[<cmd>b#<cr>]], { desc = "Other" })
mapl("bn", [[<cmd>bnext<cr>]], { desc = "Next" })
mapl("bp", [[<cmd>bprevious<cr>]], { desc = "Prev" })
mapl("bs", [[<cmd>lua Hosaka.new_scratch_buffer()<cr>]], { desc = "Scratch" })
mapl("bd", [[<cmd>lua MiniBufremove.delete()<cr>]], { desc = "Delete" })
mapl("bD", [[<cmd>lua MiniBufremove.delete(0, true)<cr>]], { desc = "Delete!" })
mapl("bw", [[<cmd>lua MiniBufremove.wipeout()<cr>]], { desc = "Wipeout" })
mapl("bW", [[<cmd>lua MiniBufremove.wipeout(0, true)<cr>]], { desc = "Wipeout!" })

-- c is for code
-- also see `plugins/nvim-lspconfig.lua` for LSP and language specific keymaps
mapl("cl", [[<cmd>lua require("quicker").toggle({ loclist=true })<cr>]], { desc = "Toggle loclist" })
mapl("cq", [[<cmd>lua require("quicker").toggle()<cr>]], { desc = "Toggle quickfix" })

-- d is for debug
-- also see `plugins/dap.lua` for DAP specific keymaps
mapl("db", [[<cmd>lua require("dap").toggle_breakpoint()<cr>]], { desc = "Toggle breakpoint" })
mapl("dB", [[<cmd>lua require("dap").clear_breakpoints()<cr>]], { desc = "Clear breakpoints" })
mapl("dr", [[<cmd>lua require("dap").continue()<cr>]], { desc = "Run" })
mapl("dR", [[<cmd>lua require("dap").restart()<cr>]], { desc = "Restart" })
mapl("dl", [[<cmd>lua require("dap").run_last()<cr>]], { desc = "Run last" })
mapl("da", [[<cmd>lua require("dap").continue()<cr>]], { desc = "Run with args" })
mapl("dc", [[<cmd>lua require("dap").run_to_cursor()<cr>]], { desc = "Continue to cursor" })
mapl("di", [[<cmd>lua require("dap").step_into()<cr>]], { desc = "Step into" })
mapl("do", [[<cmd>lua require("dap").step_out()<cr>]], { desc = "Step out" })
mapl("dn", [[<cmd>lua require("dap").step_over()<cr>]], { desc = "Step over" })
mapl("dj", [[<cmd>lua require("dap").up()<cr>]], { desc = "Up stacktrace" })
mapl("dk", [[<cmd>lua require("dap").down()<cr>]], { desc = "Down stacktrace" })
mapl("ds", [[<cmd>lua require("dap").session()<cr>]], { desc = "Session" })
mapl("dt", [[<cmd>lua require("dap").terminate()<cr>]], { desc = "Terminate" })
mapl("dh", [[<cmd>lua require("dap.ui.widgets").hover()<cr>]], { desc = "Hover" })
mapl("du", [[<cmd>lua require("dapui").toggle()<cr>]], { desc = "Toggle UI" })
mapl("dw", [[<cmd>lua require("dapui").elements.watches.add(vim.fn.expand("<cword>"))<cr>]], { desc = "Watch" })

-- e is for edit
mapl("en", [[<cmd>enew<cr>]], { desc = "New file" })
mapl("er", [[<cmd>lua Hosaka.lsp.rename_file()<cr>]], { desc = "Rename file" })
mapl("ed", [[<cmd>lua MiniFiles.open()<cr>]], { desc = "Directory" })
mapl("ec", [[<cmd>lua MiniFiles.open(vim.fn.stdpath("config"))<cr>]], { desc = "Config" })
mapl("ef", [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>]], { desc = "File directory" })
mapl("es", [[<cmd>lua MiniSessions.select()<cr>]], { desc = "Sessions" })
mapl("ew", function()
  vim.ui.input({ prompt = "Session name" }, function(input)
    if input then
      require("mini.sessions").write(input)
    end
  end)
end, { desc = "Write session" })

-- f is for find
map(",", [[<cmd>Pick buf_lines_current<cr>]], { mode = { "n", "x" }, desc = "Buffer lines", nowait = true })
mapl("<Space>", [[<cmd>Pick files<cr>]], { desc = "Files" })
mapl(",", [[<cmd>Pick open_buffers<cr>]], { desc = "Open buffers" })
mapl("?", [[<cmd>Pick oldfiles<cr>]], { desc = "Recent files" })
mapl("f/", [[<cmd>Pick history scope="/"<cr>]], { desc = "/ history" })
mapl("f:", [[<cmd>Pick history scope=":"<cr>]], { desc = ": history" })
mapl("fa", [[<cmd>Pick git_hunks scope="staged"<cr>]], { desc = "Added hunks (all)" })
mapl("fA", [[<cmd>Pick git_hunks path="%" scope="staged"<cr>]], { desc = "Added hunks (current)" })
mapl("fb", [[<cmd>Pick open_buffers<cr>]], { desc = "Open buffers" })
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
mapl("fl", [[<cmd>Pick buf_lines scope="all"<cr>]], { desc = "Lines (all)" })
mapl("fL", [[<cmd>Pick buf_lines_current<cr>]], { desc = "Lines (current)" })
mapl("fm", [[<cmd>Pick git_hunks<cr>]], { desc = "Modified hunks (all)" })
mapl("fM", [[<cmd>Pick git_hunks path="%"<cr>]], { desc = "Modified hunks (current)" })
mapl("fk", [[<cmd>Pick keymaps<cr>]], { desc = "Keymaps" })
mapl("fo", [[<cmd>Pick options<cr>]], { desc = "Options" })
mapl("fr", [[<cmd>Pick resume<cr>]], { desc = "Resume" })
mapl("fp", [[<cmd>Pick projects<cr>]], { desc = "Projects" })
mapl("fz", [[<cmd>Pick spellsuggest<cr>]], { desc = "Spelling suggestions" })
mapl("fR", [[<cmd>Pick lsp scope="references"<cr>]], { desc = "References (LSP)" })
mapl("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], { desc = "Symbol workspace (LSP)" })
mapl("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], { desc = "Symbol buffer (LSP)" })

-- g is for git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ |\ \%s --topo-order]]
mapl("gg", [[<cmd>lua Hosaka.toggle_lazygit()<cr>]], { desc = "Lazygit" })
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

-- m is for map
mapl("mc", [[<cmd>lua MiniMap.close()<cr>]], { desc = "Close" })
mapl("mf", [[<cmd>lua MiniMap.toggle_focus()<cr>]], { desc = "Focus toggle" })
mapl("mo", [[<cmd>lua MiniMap.open()<cr>]], { desc = "Open" })
mapl("mr", [[<cmd>lua MiniMap.refresh()<cr>]], { desc = "Refresh" })
mapl("ms", [[<cmd>lua MiniMap.refresh()<cr>]], { desc = "Side toggle" })
mapl("mm", [[<cmd>lua MiniMap.toggle()<cr>]], { desc = "Toggle" })

-- o is for options
-- also see `plugins/nvim-lspconfig.lua`
-- also see `plugins/nvim-treesitter-context.lua`
local option = Hosaka.toggle.option
local global = Hosaka.toggle.global

global("autoformat_disable", { name = "autoformat" }):mapl("of")
global("minipairs_disable", { name = "autopairs" }):mapl("op")
global("minitrailspace_disable", { name = "trailspace" }):mapl("oT")
-- global("minicursorword_disable", { name = "cursorword" }):mapl("oC")
option("cursorcolumn", { name = "'cursorcolumn'" }):mapl("oC")
option("cursorline", { name = "'cursorline'" }):mapl("oc")
option("number", { name = "'number'" }):mapl("on")
option("relativenumber", { name = "'relativenumber'" }):mapl("or")
option("spell", { name = "'spell'" }):mapl("os")
option("wrap", { name = "'wrap'" }):mapl("ow")
option("bg", { name = "'background'", on = "dark", off = "light" }):mapl("ob")
mapl("oz", [[<cmd>lua MiniMisc.zoom(0, { border="rounded" })<cr>]], { desc = "Toggle zoom" })

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
mapl("rdu", [[<cmd>DepsUpdate<cr>]], { desc = "Update" })
mapl("rds", [[<cmd>DepsSnapSave<cr>]], { desc = "Save snapshot" })
mapl("rdl", [[<cmd>DepsSnapLoad<cr>]], { desc = "Load snapshot" })
mapl("rdc", [[<cmd>DepsClean<cr>]], { desc = "Clean" })

-- t is for terminal
mapl("tt", [[<cmd>execute v:count1 . "ToggleTerm"<cr>]], { desc = "Toggle" })
mapl("tn", [[<cmd>TermNew <cr>]], { desc = "New" })
mapl("tf", [[<cmd>ToggleTerm direction=float<cr>]], { desc = "Float" })
mapl("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], { desc = "Horizontal" })
mapl("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], { desc = "Vertical" })
mapl("ts", [[<cmd>TermSelect<cr>]], { desc = "Select" })
mapl("tr", [[<cmd>ToggleTermSetName<cr>]], { desc = "Rename" })
mapl("tT", [[<cmd>ToggleTermToggleAll<cr>]], { desc = "Toggle all" })
mapl("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], { desc = "Send line" })
mapl("tl", [[<cmd>ToggleTermSendVisualSelection<cr><esc>]], { mode = "x", desc = "Send selection" })
mapl("tP", [[<cmd>lua Hosaka.toggle_python()<cr>]], { desc = "Python REPL" })
mapl("tN", [[<cmd>lua Hosaka.toggle_node()<cr>]], { desc = "Node REPL" })

-- v is for visits
-- also see `plugins/mini.visits.lua`
mapl("vp", [[<cmd>Pick visit_paths cwd=""<cr>]], { desc = "Path visits (all)" })
mapl("vP", [[<cmd>Pick visit_paths<cr>]], { desc = "Path visits (cwd)" })
mapl("vl", [[<cmd>Pick visit_labels cwd=""<cr>]], { desc = "All labels (all)" })
mapl("vL", [[<cmd>Pick visit_labels<cr>]], { desc = "All labels (cwd)" })
-- core visits only
mapl("vc", [[<cmd>Pick visits label="core" cwd=""<cr>]], { desc = "Core visits (all)" })
mapl("vC", [[<cmd>Pick visits label="core"<cr>]], { desc = "Core visits (cwd)" })
mapl("va", [[<cmd>lua MiniVisits.add_label("core")<cr>]], { desc = "Add core label" })
mapl("vA", [[<cmd>lua MiniVisits.add_label()<cr>]], { desc = "Add label" })
mapl("vr", [[<cmd>lua MiniVisits.remove_label("core")<cr>]], { desc = "Remove core label" })
mapl("vR", [[<cmd>lua MiniVisits.remove_label()<cr>]], { desc = "Remove label" })
