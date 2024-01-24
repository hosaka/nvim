-- global table for mini.clue groups
hosaka.leader_group_clues = {
  { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<Leader>c", desc = "+Code" },
  { mode = "n", keys = "<Leader>e", desc = "+Edit" },
  { mode = "n", keys = "<Leader>f", desc = "+Find" },
  { mode = "n", keys = "<Leader>g", desc = "+Git" },
  { mode = "x", keys = "<Leader>g", desc = "+Git" },
  { mode = "n", keys = "<Leader>o", desc = "+Option" },
  { mode = "n", keys = "<Leader>q", desc = "+Quit" },
  { mode = "n", keys = "<Leader>r", desc = "+Run" },
  { mode = "n", keys = "<Leader>t", desc = "+Terminal" },

  { mode = "x", keys = "<Leader>c", desc = "+Code" },
  { mode = "x", keys = "<Leader>t", desc = "+Terminal" },
}

local map_leader = function(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, "<Leader>" .. suffix, rhs, opts)
end

local nmap_leader = function(suffix, rhs, desc, opts)
  map_leader("n", suffix, rhs, desc, opts)
end

local xmap_leader = function(suffix, rhs, desc, opts)
  map_leader("x", suffix, rhs, desc, opts)
end

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

-- b is for buffer
nmap_leader("bb", [[<cmd>b#<cr>]], "Other")
nmap_leader("bn", [[<cmd>bnext<cr>]], "Next")
nmap_leader("bp", [[<cmd>bprevious<cr>]], "Prev")
nmap_leader("bs", [[<cmd>lua hosaka.new_scratch_buffer()<cr>]], "Scratch")
nmap_leader("bd", [[<cmd>lua require("mini.bufremove").delete()<cr>]], "Delete")
nmap_leader("bD", [[<cmd>lua require("mini.bufremove").delete(0, true)<cr>]], "Delete!")
nmap_leader("bw", [[<cmd>lua require("mini.bufremove").wipeout()<cr>]], "Wipeout")
nmap_leader("bW", [[<cmd>lua require("mini.bufremove").wipeout(0, true)<cr>]], "Wipeout!")

-- c is for code
-- see `config/nvim-lspconfig.lua` for LSP and language specific keymaps
nmap_leader("cd", [[<cmd>lua vim.diagnostic.open_float()<cr>]], "Diagnostic popup")
nmap_leader("cD", [[<cmd>lua vim.diagnostic.setloclist()<cr>]], "Diagnostic list")
nmap_leader("cj", [[<cmd>lua vim.diagnostic.goto_next()<cr>]], "Next diagnostic")
nmap_leader("ck", [[<cmd>lua vim.diagnostic.goto_prev()<cr>]], "Prev diagnostic")
nmap_leader("cl", [[<cmd>lopen<cr>]], "Location list")
nmap_leader("cq", [[<cmd>lua hosaka.toggle_quickfix()<cr>]], "Quickfix list")

-- e is for edit
nmap_leader("en", [[<cmd>enew<cr>]], "New file")
nmap_leader("ed", [[<cmd>lua MiniFiles.open()<cr>]], "Directory")
nmap_leader("ef", [[<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>]], "File directory")
nmap_leader("es", [[<cmd>lua MiniSessions.select()<cr>]], "Select session")
nmap_leader("ew", function()
  vim.ui.input({ prompt = "Session name:" }, function(input)
    if input then
      MiniSessions.write(input)
    end
  end)
end, "Write session")

local pick_buffers
pick_buffers = function()
  MiniPick.builtin.buffers(nil, {
    mappings = {
      delete_buffer = {
        char = "<C-d>",
        func = function()
          local matches = MiniPick.get_picker_matches()
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
nmap_leader("fL", [[<cmd>Pick buf_lines scope='current'<cr>]], "Lines (current)")
nmap_leader("fm", [[<cmd>Pick git_hunks<cr>]], "Modified hunks (all)")
nmap_leader("fM", [[<cmd>Pick git_hunks path='%'<cr>]], "Modified hunks (current)")
nmap_leader("fk", [[<cmd>Pick keymaps<cr>]], "Keymaps")
nmap_leader("fo", [[<cmd>Pick oldfiles<cr>]], "Old files")
nmap_leader("fO", [[<cmd>Pick options<cr>]], "Options")
nmap_leader("fr", [[<cmd>Pick resume<cr>]], "Resume")
nmap_leader("fR", [[<cmd>Pick lsp scope='references'<cr>]], "References (LSP)")
nmap_leader("fs", [[<cmd>Pick lsp scope="workspace_symbol"<cr>]], "Symbol workspace (LSP)")
nmap_leader("fS", [[<cmd>Pick lsp scope="document_symbol"<cr>]], "Symbol buffer (LSP)")

-- g is for git
nmap_leader("gg", [[<cmd>lua require('neogit').open()<cr>]], "Neogit")
nmap_leader("gG", [[<cmd>lua hosaka.toggle_lazygit()<cr>]], "Lazygit")
nmap_leader("gc", [[<cmd>lua require('neogit').open({'commit'})<cr>]], "Commit")
nmap_leader("gd", [[<cmd>DiffviewOpen<cr>]], "Diffview")

-- o is for option
nmap_leader("ot", [[<cmd>TSContextToggle<cr>]], "Toggle treesitter context")
nmap_leader("oz", [[<cmd>lua MiniMisc.zoom()<cr>]], "Toggle zoom")
nmap_leader("op", function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
end, "Toggle autopairs")
nmap_leader("of", function()
  vim.g.autoformat_disable = not vim.g.autoformat_disable
end, "Toggle autoformat (all)")
nmap_leader("oF", function()
  vim.b.autoformat_disable = not vim.b.autoformat_disable
end, "Toggle autoformat (current)")

-- q is for quit
nmap_leader("qq", [[<cmd>quitall<cr>]], "Quit all")
nmap_leader("qQ", [[<cmd>quitall!<cr>]], "Quit all!")

-- r is for run and it is created when LSPs attach to buffers

-- t is for terminal
nmap_leader("tt", [[<cmd>ToggleTerm<cr>]], "Terminal toggle")
nmap_leader("tf", [[<cmd>ToggleTerm direction=float<cr>]], "Terminal float")
nmap_leader("th", [[<cmd>ToggleTerm size=10 direction=horizontal<cr>]], "Terminal horizontal")
nmap_leader("tv", [[<cmd>ToggleTerm size=80 direction=vertical<cr>]], "Terminal vertical")
nmap_leader("ts", [[<cmd>TermSelect<cr>]], "Terminal select")
nmap_leader("tl", [[<cmd>ToggleTermSendCurrentLine<cr>]], "Terminal send line")
xmap_leader("tl", [[<cmd>ToggleTermSendVisualSelection<cr><esc>]], "Terminal send selection")
