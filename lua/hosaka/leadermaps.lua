-- global table for mini.clue groups
hosaka.leader_group_clues = {
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>c", desc = "+Code" },
  { mode = "n", keys = "<Leader>e", desc = "+Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>o", desc = "+Option" },
  { mode = "n", keys = "<Leader>q", desc = "+Quit" },
  { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
}

local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("n", "<Leader>" .. suffix, rhs, opts)
end

local xmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("x", "<Leader>" .. suffix, rhs, opts)
end

-- tabs
-- map("n", "<Leader><Tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<Leader><Tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<Leader><Tab><Tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<Leader><Tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<Leader><Tab>d", "<cmd>tabclose<cr>", { desc = "Delete Tab" })
-- map("n", "<Leader><Tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- b is for buffer
nmap_leader("bb", [[<cmd>b#<cr>]], "Other")
nmap_leader("bd", [[<cmd>lua require("mini.bufremove").delete()<cr>]], "Delete")
nmap_leader("bD", [[<cmd>lua require("mini.bufremove").delete(0, true)<cr>]], "Delete!")
nmap_leader("bw", [[<cmd>lua require("mini.bufremove").wipeout()<cr>]], "Wipeout")
nmap_leader("bW", [[<cmd>lua require("mini.bufremove").wipeout(0, true)<cr>]], "Wipeout!")

-- c is for code
nmap_leader("ca", [[<cmd>lua vim.lsp.buf.code_action()<cr>]], "Action popup")
xmap_leader("ca", [[<cmd>lua vim.lsp.buf.code_action()<cr>]], "Action popup")
nmap_leader("cr", [[<cmd>lua vim.lsp.buf.rename()<cr>]], "Rename")
nmap_leader("cR", [[<cmd>lua vim.lsp.buf.references()<cr>]], "References")
nmap_leader("cs", [[<cmd>lua vim.lsp.buf.definition()<cr>]], "Source definition")
nmap_leader("ct", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], "Type definition")

nmap_leader("cf", [[<cmd>lua vim.lsp.buf.format()<cr><esc>]], "Format")
xmap_leader("cf", [[<cmd>lua vim.lsp.buf.format()<cr><esc>]], "Format selection")
nmap_leader("cd", [[<cmd>lua vim.diagnostic.open_float()<cr>]], "Diagnostic popup")
nmap_leader("cj", [[<cmd>lua vim.diagnostic.goto_next()<cr>]], "Next diagnostic")
nmap_leader("ck", [[<cmd>lua vim.diagnostic.goto_prev()<cr>]], "Prev diagnostic")

nmap_leader("cl", [[<cmd>lopen<cr>]], "Location list")
nmap_leader("cq", [[<cmd>copen<cr>]], "Quickfix list")

-- e is for edit
nmap_leader("en", [[<cmd>enew<cr>]], "New file")
nmap_leader("ed", [[<cmd>lua require("oil").toggle_float()<cr>]], "Directory")
nmap_leader("es", [[<cmd>lua MiniSessions.select()<cr>]], "Select session")
-- nmap_leader("ew", [[<cmd>lua MiniSessions.wrter()<cr>]], "Write session")

-- f is for find
nmap_leader("f/", [[<cmd>Pick history scope="/"<cr>]], "/ history")
nmap_leader("f:", [[<cmd>Pick history scope=":"<cr>]], ": history")
nmap_leader(",", [[<cmd>Pick buffers<cr>]], "Open buffers")
nmap_leader("fb", [[<cmd>Pick buffers<cr>]], "Open buffers")
nmap_leader("fg", [[<cmd>Pick grep_live<cr>]], "Grep live")
nmap_leader("fG", [[<cmd>Pick grep pattern="<cword>"<cr>]], "Grep word")
nmap_leader("fc", [[<cmd>Pick git_commits choose_type="show_patch"<cr>]], "Commits")
nmap_leader("fC", [[<cmd>Pick git_commits path="%" choose_type="show_patch"<cr>]], "Buffer commits")
nmap_leader("fr", [[<cmd>lua require("spectre").open()<cr>]], "Replace in files")

nmap_leader("ff", [[<cmd>Pick files<cr>]], "Files")
nmap_leader("<Space>", [[<cmd>Pick files<cr>]], "Files")
nmap_leader("fh", [[<cmd>Pick help<cr>]], "Help")
nmap_leader("fR", [[<cmd>Pick resume<cr>]], "Resume")
nmap_leader("fo", [[<cmd>Pick options<cr>]], "Option")

nmap_leader("fd", [[<cmd>Pick diagnostic scope="all"<cr>]], "Diagnostic workspace")
nmap_leader("fD", [[<cmd>Pick diagnostic scope="current"<cr>]], "Diagnostic buffer")
nmap_leader("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], "Symbol workspace")
nmap_leader("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], "Symbol buffer")

-- g is for git
nmap_leader("gg", [[<cmd>lua require('neogit').open()<cr>]], "Neogit")
nmap_leader("gG", [[<cmd>lua hosaka.toggle_lazygit()<cr>]], "Lazygit")
nmap_leader("gc", [[<cmd>lua require('neogit').open({'commit'})<cr>]], "Commit")
nmap_leader("gd", [[<cmd>DiffviewOpen<cr>]], "Diffview")

nmap_leader("ga", [[<cmd>lua require("gitsigns").stage_hunk()<cr>]], "Add hunk")
nmap_leader("gA", [[<cmd>lua require("gitsigns").stage_buffer()<cr>]], "Add buffer")
nmap_leader("gb", [[<cmd>lua require("gitsigns").blame_line()<cr>]], "Blame line")
nmap_leader("gp", [[<cmd>lua require("gitsigns").preview_hunk()<cr>]], "Preview hunk")
nmap_leader("gr", [[<cmd>lua require("gitsigns").reset_hunk()<cr>]], "Reset hunk")
nmap_leader("gR", [[<cmd>lua require("gitsigns").reset_buffer()<cr>]], "Reset buffer")
nmap_leader("gu", [[<cmd>lua require("gitsigns").undo_stage_hunk()<cr>]], "Undo add hunk")
nmap_leader("gq", [[<cmd>lua require("gitsigns").setqflist()<cr>:open<cr>]], "Quickfix hunks")

-- o is for option
nmap_leader("ot", [[<cmd>lua vim.lsp.inlay_hint(0)<cr>]], "Toggle inlay hints")
nmap_leader("oT", [[<cmd>TSContextToggle<cr>]], "Toggle treesitter context")
nmap_leader("oz", [[<cmd>lua MiniMisc.zoom()<cr>]], "Toggle zoom")

-- q is for quit
nmap_leader("qq", [[<cmd>quitall<cr>]], "Quit all")
nmap_leader("qQ", [[<cmd>quitall!<cr>]], "Quit all!")

-- t is for terminal
nmap_leader("tt", [[<cmd>ToggleTerm<cr>]], "Terminal")
nmap_leader("tf", [[<cmd>ToggleTerm direction=float<cr>]], "Terminal Float")
nmap_leader("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Terminal Horizontal")
nmap_leader("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], "Terminal Vertical")
nmap_leader("ts", [[<cmd>TermSelect<cr>]], "Terminal Select")
nmap_leader("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], "Terminal Send Line")
