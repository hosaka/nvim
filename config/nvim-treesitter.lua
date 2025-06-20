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
}

local not_installed = function(lang)
  return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(not_installed, ensure_installed)
if #to_install > 0 then
  require("nvim-treesitter").install(to_install)
end

-- justfile
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").just = {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
      },
      maintainers = { "@IndianBoy42" },
    }
  end,
})

-- todo: need to manually bind all the keymaps
-- nvim-treesitter-textobjects
require("nvim-treesitter-textobjects").setup({
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      -- most keymaps are already handled by mini.ai
      ["l="] = { query = "@assignment.lhs", desc = "Left hand side of an assignment" },
      ["r="] = { query = "@assignment.rhs", desc = "Right hand side of an assignment" },
    },
  },
  move = {
    enable = true,
    set_jumps = true, -- updates jumplist (go back with C-o)
    goto_next_start = {
      ["]m"] = { query = "@function.outer", desc = "Function start forward" },
    },
    goto_next_end = {
      ["]M"] = { query = "@function.outer", desc = "Function end forward" },
    },
    goto_previous_start = {
      ["[m"] = { query = "@function.outer", desc = "Function start backward" },
    },
    goto_previous_end = {
      ["[M"] = { query = "@function.outer", desc = "Function end backward" },
    },
  },
  swap = {
    enable = true,
    swap_next = {
      ["<leader>cp"] = { query = "@parameter.inner", desc = "Swap next parameter" },
    },
    swap_previous = {
      ["<leader>cP"] = { query = "@parameter.inner", desc = "Swap prev parameter" },
    },
  },
})

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
