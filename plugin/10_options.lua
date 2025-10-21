-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o, opt = vim.o, vim.opt

local function concat(tbl)
  return table.concat(tbl, ",")
end

-- General
o.autowrite = true -- Enable auto write
o.backup = false -- Don't store backups
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.mouse = "a" -- Enable mouse for all available modes
o.sessionoptions = concat({ "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }) -- Defines what needs to be saved in a session
o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit stored shared data
o.switchbuf = "usetab" -- Use already opened buffers when switching
o.undofile = true -- Enable persistent undo
o.wildmode = "longest:full,full" -- Command-line completion mode
o.writebackup = false -- Don't store backups while overwriting the file
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- Appearance
o.breakindent = true -- Indent wrapped lines to match line start
o.breakindentopt = "list:-1" -- Add padding for lists when wrap is on
o.colorcolumn = "+1" -- Draw column on the right of maximum width
o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
o.cursorline = true -- Enable highlighting of the current line
o.cursorlineopt = concat({ "screenline", "number" }) -- Show cursor line per screen line
o.laststatus = 3 -- Always show statusline in the last window only
o.linebreak = true -- Wrap long lines at 'breakat' if 'wrap' is set
o.list = true -- Show whitespaces and helper symbols
o.number = true -- Show line numbers
o.pumblend = 10 -- Popup transparency
o.pumheight = 10 -- Popup max number of entries
o.relativenumber = true -- Relative line numbers
o.ruler = false -- Don't show curor position
o.scrolloff = 4 -- Lines to keep above and below the cursor
o.shortmess = "FOSWaco" -- Disable some messages from ins-completion-menu
o.showmode = false -- Don't show mode since we have a statusline
o.sidescrolloff = 8 -- Columns to keep to the left and right around the cursor
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.virtualedit = "block" -- Allow cursor to move to virtual space in visual block mode
o.winblend = 10 -- Floating windows transparency
o.winminwidth = 5 -- Minimum window width
o.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 0 then
  o.termguicolors = true -- Enable gui colors (>=0.10 enables this by default)
end

o.fillchars = concat({
  "eob: ",
  "fold:╌",
  "horiz:═",
  "horizdown:╦",
  "horizup:╩",
  "vert:║",
  "verthoriz:╬",
  "vertleft:╣",
  "vertright:╠",
}) -- Special UI symbols
o.listchars = concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }) -- Special text symbols

if vim.fn.has("nvim-0.9") == 1 then
  o.splitkeep = "screen" -- Reduce scroll during window split
  opt.shortmess:append("WcC") -- Reduce command line messages
else
  opt.shortmess:append("Wc") -- Reduce command line messages
end

if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
end

-- enable syntax highlight if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd([[syntax enable]])
end

vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

-- Editing
o.autoindent = true -- Use auto indent
o.completeopt = concat({ "menuone", "noinsert", "noselect" }) -- Customize completions
o.expandtab = true -- Use spaces instead of tabs
o.formatoptions = "rnqjl1" -- Improve comment editing
o.grepformat = "%f:%l:%c:%m" -- Grep formatting
o.grepprg = "rg --vimgrep --smart-case" -- Set rg as grep
o.ignorecase = true -- Ignore case
o.inccommand = "nosplit" -- Preview incremental substitute
o.incsearch = true -- Show search results while typing
o.infercase = true -- Infer letter cases
opt.iskeyword:append("-") -- Treat dash-separated-words as a word text object
o.jumpoptions = "stack" -- Jump list behaves like a stack
o.shiftround = true -- Round indent
o.shiftwidth = 2 -- Size of an indent
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.tabstop = 2 -- Number of spaces tabs count for
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.virtualedit = "block" -- Allow going past the end line in visual block mode

-- `bigfile` filetype
-- some plugins will be disabled for files larger than this size, see `after/ftplugin/bigfile.lua`
vim.g.bigfile_size = 1024 * 1024 * 1 -- 1MB
vim.g.bigfile_line_length = 1000
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if not path or not buf or vim.bo[buf].filetype == "bigfile" then
          return
        end
        if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then
          return
        end
        local size = vim.fn.getfsize(path)
        if size <= 0 then
          return
        end
        if size > vim.g.bigfile_size then
          return "bigfile"
        end
        local lines = vim.api.nvim_buf_line_count(buf)
        return (size - lines) / lines > vim.g.bigfile_line_length and "bigfile" or nil
      end,
    },
  },
})

-- Pattern for a start of 'numbered' list (used in `gw`).
-- At least one special character (0-9, -, +, *) optionally followed by some
-- punctuation (. or ')') followed by at least one space.
o.formatlistpat = [[^s\*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Spelling
opt.complete:append("kspell") -- Add spellcheck options for autocomplete
opt.complete:remove("t") -- Don't use tags for completion
o.dictionary = vim.fn.stdpath("config") .. "/misc/dict/english.txt"
o.spelllang = "en" -- Define spelling dictionaries
o.spelloptions = concat({ "camel", "noplainbuffer" }) -- Treat parts of calemCase words as separate words, only for buffers with syntax

-- Folding
o.foldcolumn = "0" -- No need to see the fold column
o.foldenable = true -- Enable folding
o.foldlevel = 99 -- Higher fold level
o.foldlevelstart = 99 -- Higher fold level
o.foldmethod = "indent" -- Set indent folding method

if vim.treesitter.foldexpr then
  o.foldmethod = "expr" -- Set expr folding methond
  o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use tresitter as folding expr
end
if vim.treesitter.foldtext then
  o.foldtext = "v:lua.vim.treesitter.foldtext()"
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
