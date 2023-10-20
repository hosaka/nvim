-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- General
opt.autowrite = true -- Enable auto write
opt.backup = false -- Don't store backups
opt.mouse = "a" -- Enable mouse
opt.switchbuf = "usetab" -- Use already opened buffers when switching
opt.writebackup = false -- Don't store backups
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } -- Defines what needs to be saved in a session
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Undo
opt.undodir = vim.fn.stdpath("config") .. "/misc/undodir" -- Persistent undo dir
opt.undofile = true -- Enable persistentt undo

-- UI
opt.breakindent = true -- Indent wrapped lines to match line start
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.cursorline = true -- Enable highlighting of the current line
opt.laststatus = 2 -- Always show statusline
opt.linebreak = true -- Wrap long lines at 'breakat' if 'wrap' is set
opt.list = true -- Show whitespaces
opt.number = true -- Show line numbers
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Don't show curor position
opt.scrolloff = 4 -- Lines to keep above and below the cursor
opt.shortmess = "aoOWIFc" -- Disable some messages from ins-completion-menu
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns to keep to the left and right around the cursor
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- Enable gui colors
opt.virtualedit = "block" -- Allow cursor to move to virtual space in visual block mode
opt.winblend = 10 -- Floating window blend
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.9") == 1 then
  opt.splitkeep = "screen" -- Reduce scroll during window split
  opt.shortmess:append("C") -- Don't show "Scanning..." messages
end

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

-- Editing
opt.autoindent = true -- Use auto indent
opt.completeopt = "menuone,noinsert,noselect" -- Customize completions
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "rqnl1j" -- Improve comment editing
opt.grepformat = "%f:%l:%c:%m" -- Grep formatting
opt.grepprg = "rg --vimgrep" -- Set rg as grep
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.incsearch = true -- Show search results while typing
opt.infercase = true -- Infer letter cases
opt.iskeyword:append("-") -- Treat dash-separated-words as a word text object
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 2 -- Number of spaces tabs count for
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow going past the end line in visual block mode

-- Pattern for a start of 'numbered' list.
-- At least one special character (0-9, -, +, *) optionally followed by some
-- punctuation (. or ')') followed by at least one space.
opt.formatlistpat = [[^s\*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Spelling
opt.complete:append("kspell") -- Add spellcheck options for autocomplete
opt.complete:remove("t") -- Don't use tags for completion
opt.dictionary = vim.fn.stdpath("config") .. "/misc/dict/english.txt"
opt.spelllang = "en" -- Define spelling dictionaries
opt.spelloptions = "camel" -- Treat parts of calemCase words as separate words

-- Folding
opt.foldenable = true -- Enable folding
opt.foldlevel = 99 -- Higher fold level

if vim.treesitter.foldexpr then
  opt.foldmethod = "expr" -- Set expr folding methond
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use tresitter as folding expr
else
  opt.foldmethod = "indent"
end
if vim.treesitter.foldtext then
  opt.foldtext = "v:lua.vim.treesitter.foldtext()"
end

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- This needs a FileType autocmd to persist.
vim.cmd([[augroup CustomSettings]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=o]])
vim.cmd([[augroup END]])

-- Clipboard
if vim.fn.has("wsl") then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Neovide
if vim.g.neovide then
  opt.guifont = "FiraCode Nerd Font:h11"
  opt.winblend = 30
  opt.pumblend = 30
end