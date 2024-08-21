require("markview").setup({
  -- modes where preview is enabled
  modes = { "n", "i", "no", "c" },
  -- modes where hybrid mode is enabled
  hybrid_modes = { "i" },
  callbacks = {
    on_enable = function(_, win)
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = "c"
    end,
  },
})
