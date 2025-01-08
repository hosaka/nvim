require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = {
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
  },
  -- nvim-ts-autotag
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = { "vimdoc" },
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gnn",
      node_incrementqal = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false,
  },
  -- andymass/vim-matchup
  matchup = {
    enable = true,
  },
  -- nvim-treesitter-textobjects
  textobjects = {
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
  },
})

-- justfile
require("nvim-treesitter.parsers").get_parser_configs().just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  maintainers = { "@IndianBoy42" },
}
