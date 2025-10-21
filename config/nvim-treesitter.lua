-- these parsers will always be installed
-- any others supported by tree-sitter will be installed when a filetype is opened and no compatible
-- parser is bundled with neovim
local languages = {
  "bash",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "html",
  "ini",
  "json",
  "just",
  "toml",
  "yaml",
}

local treesitter = require("nvim-treesitter")
local treesitter_config = require("nvim-treesitter.config")
local parsers_installed = treesitter_config.get_installed("parsers")
local parsers_to_install = vim
  .iter(languages)
  :filter(function(parser)
    return not vim.tbl_contains(parsers_installed, parser)
  end)
  :totable()
if #parsers_to_install > 0 then
  treesitter.install(parsers_to_install)
end

local function treesitter_start(buffer, lang)
  vim.treesitter.start(buffer, lang)
  vim.bo[buffer].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
      vim.notify(string.format("No treesitter language found for %s", filetype), vim.log.levels.WARN)
      return
    end

    local config = require("nvim-treesitter.config")

    if not vim.tbl_contains(config.get_available(), lang) then
      return
    end

    -- if neovim treesitter already has a bundled parser, no need to install it again
    if vim.treesitter.get_parser(buffer, lang, { error = false }) == nil then
      -- if parser is available but not installed, install it first
      if not vim.tbl_contains(config.get_installed("parsers"), lang) then
        vim.notify(string.format("Installing treesitter parser for %s", lang), vim.log.levels.INFO)
        treesitter.install({ lang }):await(function()
          treesitter_start(buffer, lang)
        end)
        return
      end
    end

    -- start treesitter as usual
    treesitter_start(buffer, lang)
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
