-- enable syntax highlight if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd([[syntax enable]])
end

require("nvim-treesitter.configs").setup({
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
})
