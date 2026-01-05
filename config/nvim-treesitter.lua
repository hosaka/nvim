-- these parsers will always be installed
-- any others supported by treesitter will be installed when a filetype is opened and no compatible
-- parser is bundled with neovim
local languages = {
  "bash",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "gitignore",
  "html",
  "ini",
  "json",
  "just",
  "toml",
  "yaml",
}

local ts = require("nvim-treesitter")
local parsers_to_install = vim
  .iter(languages)
  :filter(function(parser)
    return not vim.tbl_contains(ts.get_installed("parsers"), parser)
  end)
  :totable()
if #parsers_to_install > 0 then
  ts.install(parsers_to_install)
end

-- better filetypes
vim.filetype.add({
  pattern = {
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github-actions",
    ["%.env.*"] = "dotenv",
  },
})

vim.treesitter.language.register("yaml", "yaml.docker-compose")
vim.treesitter.language.register("yaml", "yaml.github-actions")
vim.treesitter.language.register("bash", "dotenv")

-- indentexpr should not be changed for parsers bundled with nvim
local function nvim_treesitter_start(buffer, lang, indent)
  vim.treesitter.start(buffer, lang)
  indent = indent == nil and true or indent
  if indent then
    vim.bo[buffer].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable Treesitter",
  group = Hosaka.augroup("enable_treesitter"),
  callback = function(event)
    local buffer = event.buf
    local filetype = event.match

    if filetype == "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(filetype)
    if not lang then
      vim.notify(string.format("No TS language found for %s", filetype), vim.log.levels.WARN)
      return
    end

    local ts = require("nvim-treesitter")

    -- if a parser is already installed, start it as usual
    -- if there is a parser bundled with nvim, no need to install it again
    -- otherwise, if parser is available, try to install it
    if vim.tbl_contains(ts.get_installed("parsers"), lang) then
      nvim_treesitter_start(buffer, lang)
    elseif vim.treesitter.language.add(lang) then
      nvim_treesitter_start(buffer, lang, false)
    elseif vim.tbl_contains(ts.get_available(), lang) then
      vim.notify(string.format("Installing TS parser for %s", lang), vim.log.levels.INFO)
      treesitter.install({ lang }):await(function()
        nvim_treesitter_start(buffer, lang)
      end)
    end
  end,
})

-- nvim-treesitter-textobjects
require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true, -- updates jumplist (go back with C-o)
  },
})

local map = Hosaka.keymap.map
local mapl = Hosaka.keymap.mapl

-- selecting textobjects
-- most are already handled by mini.ai (e.g. `vam` to select around function)
local select = require("nvim-treesitter-textobjects.select")

map("l=", function()
  select.select_textobject("@assignment.lhs")
end, { mode = { "x", "o" }, desc = "Left hand side of an assignment" })
map("r=", function()
  select.select_textobject("@assignment.rhs")
end, { mode = { "x", "o" }, desc = "Right hand side of an assignment" })

-- moving textobjects
local move = require("nvim-treesitter-textobjects.move")

map("]m", function()
  move.goto_next_start("@function.outer")
end, { mode = { "n", "x", "o" }, desc = "Function start forward" })
map("]M", function()
  move.goto_next_end("@function.outer")
end, { mode = { "n", "x", "o" }, desc = "Function end forward" })
map("[m", function()
  move.goto_previous_start("@function.outer")
end, { mode = { "n", "x", "o" }, desc = "Function start backward" })
map("[M", function()
  move.goto_previous_end("@function.outer")
end, { mode = { "n", "x", "o" }, desc = "Function end backward" })

-- swapping textobjects
local swap = require("nvim-treesitter-textobjects.swap")

mapl("cp", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
mapl("cP", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap prev parameter" })

-- nvim-ts-autotag
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
})

-- vim-matchup
require("match-up").setup({
  treesitter = {
    enabled = true,
  },
})

-- nvim-treesitter-context
local context = require("treesitter-context")
context.setup({
  mode = "cursor",
  max_lines = 3,
})

Hosaka.toggle({
  name = "context",
  get = context.enabled,
  set = context.toggle,
}):mapl("ot")
