-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o, opt = vim.o, vim.opt

-- General
opt.autowrite = true -- Enable auto write
opt.backup = false -- Don't store backups
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.mouse = "a" -- Enable mouse for all available modes
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
} -- Defines what needs to be saved in a session
opt.switchbuf = "usetab" -- Use already opened buffers when switching
opt.undofile = true -- Enable persistent undo
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.writebackup = false -- Don't store backups while overwriting the file
opt.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit stored shared data
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- Appearance
opt.breakindent = true -- Indent wrapped lines to match line start
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.cursorline = true -- Enable highlighting of the current line
opt.laststatus = 3 -- Always show statusline in the last window only
opt.linebreak = true -- Wrap long lines at 'breakat' if 'wrap' is set
opt.list = true -- Show whitespaces and helper symbols
opt.number = true -- Show line numbers
opt.pumblend = 10 -- Popup transparency
opt.pumheight = 10 -- Popup max number of entries
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Don't show curor position
opt.scrolloff = 4 -- Lines to keep above and below the cursor
opt.shortmess = "FOSWaco" -- Disable some messages from ins-completion-menu
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns to keep to the left and right around the cursor
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.virtualedit = "block" -- Allow cursor to move to virtual space in visual block mode
opt.winblend = 10 -- Floating windows transparency
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 0 then
  opt.termguicolors = true -- Enable gui colors (>=0.10 enables this by default)
end

o.fillchars = table.concat({
  "eob: ",
  "fold:╌",
  "horiz:═",
  "horizdown:╦",
  "horizup:╩",
  "vert:║",
  "verthoriz:╬",
  "vertleft:╣",
  "vertright:╠",
}, ",") -- Special UI symbols
o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",") -- Special text symbols
o.cursorlineopt = table.concat({ "screenline", "number" }, ",") -- Do not show screen line when wrap is on
o.breakindentopt = "list:-1" -- Add padding for lists when wrap is on

if vim.fn.has("nvim-0.9") == 1 then
  opt.splitkeep = "screen" -- Reduce scroll during window split
  opt.shortmess:append("WcC") -- Reduce command line messages
else
  opt.shortmess:append("Wc") -- Reduce command line messages
end

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

-- enable syntax highlight if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd([[syntax enable]])
end

vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

-- Editing
opt.autoindent = true -- Use auto indent
opt.completeopt = { "menuone", "noinsert", "noselect" } -- Customize completions
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "rnqjl1" -- Improve comment editing
opt.grepformat = "%f:%l:%c:%m" -- Grep formatting
opt.grepprg = "rg --vimgrep --smart-case" -- Set rg as grep
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.incsearch = true -- Show search results while typing
opt.infercase = true -- Infer letter cases
opt.iskeyword:append("-") -- Treat dash-separated-words as a word text object
opt.jumpoptions = "stack" -- Jump list behaves like a stack
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 2 -- Number of spaces tabs count for
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow going past the end line in visual block mode

-- `bigfile` filetype
-- some plugins will be disabled for files larger than this size
vim.g.bigfile_size = 1024 * 1024 * 1 -- 1MB
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and "bigfile"
          or nil
      end,
    },
  },
})

-- Pattern for a start of 'numbered' list.
-- At least one special character (0-9, -, +, *) optionally followed by some
-- punctuation (. or ')') followed by at least one space.
opt.formatlistpat = [[^s\*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Spelling
opt.complete:append("kspell") -- Add spellcheck options for autocomplete
opt.complete:remove("t") -- Don't use tags for completion
opt.dictionary = vim.fn.stdpath("config") .. "/misc/dict/english.txt"
opt.spelllang = "en" -- Define spelling dictionaries
opt.spelloptions = { "camel", "noplainbuffer" } -- Treat parts of calemCase words as separate words, only ffor buffers with syntax

-- Folding
opt.foldenable = true -- Enable folding
opt.foldlevel = 99 -- Higher fold level
opt.foldmethod = "indent" -- Set indent folding method

if vim.treesitter.foldexpr then
  opt.foldmethod = "expr" -- Set expr folding methond
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use tresitter as folding expr
end
if vim.treesitter.foldtext then
  opt.foldtext = "v:lua.vim.treesitter.foldtext()"
end

if vim.fn.has("nvim-0.11") == 1 then
  o.winborder = "rounded" -- Use rounded border by default
  opt.completeopt:append("fuzzy") -- Use fuzzy matching for built-in completion
end

-- Diagnostics (delayed to avoid sourcing `vim.diagnostic` on startup)
require("mini.deps").later(function()
  vim.diagnostic.config({
    -- underline = false,
    severity_sort = true,
    -- Don't update diagnostics when typing
    update_in_insert = false,
    signs = {
      -- Always highest priority
      priority = 9999,
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      },
      numhl = {
        [vim.diagnostic.severity.WARN] = "WarningMsg",
      },
    },
  })
end)

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

-- Netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Disable runtime plugins
vim.g.editorconfig = false -- Support for .editorconfig
vim.g.loaded_man = 1 -- View manpages in Nvim
vim.g.loaded_matchit = 1 -- Extended matching with % (replaced with vim-matchup)
vim.g.loaded_matchparen = 1 -- Highlight matching parens (replaced with vim-matchup)
-- vim.g.loaded_netrw = 1 -- Netrw (aka Explore)
-- vim.g.loaded_netrwPlugin = 1 -- Netrw plugin
vim.g.loaded_remote_plugins = 1 -- Support for remote plugins
-- vim.g.loaded_shada_plugin = 1 -- Shared Data file
vim.g.loaded_spellfile_plugin = 1 -- Support for downloading spell files
vim.g.loaded_gzip = 1 -- Support for editing gzip archives
vim.g.loaded_tar = 1 -- Support for editing tar archives
vim.g.loaded_tarPlugin = 1 -- Plugin for tar archives
vim.g.loaded_zip = 1 -- Support for editing zip archives
vim.g.loaded_zipPlugin = 1 -- Plugin for zip archives
vim.g.loaded_2html_plugin = 1 -- Convert window into HTML
vim.g.loaded_tutor_mode_plugin = 1 -- Interactive tutorials

vim.g.loaded_python3_provider = 0 -- Python3 plugin provider
vim.g.loaded_ruby_provider = 0 -- Ruby plugin provider
vim.g.loaded_perl_provider = 0 -- Perl plugin provider
vim.g.loaded_node_provider = 0 -- Node plugin provider

-- Plugins
vim.g.minipairs_disable = true
vim.g.autoformat_disable = false
