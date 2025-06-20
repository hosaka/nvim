local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "just",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

local not_installed = function(lang)
  return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(not_installed, ensure_installed)
if #to_install > 0 then
  require("nvim-treesitter").install(to_install)
end

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

-- todo: andymass/vim-matchup

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
