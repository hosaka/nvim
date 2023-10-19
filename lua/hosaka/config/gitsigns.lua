require("gitsigns").setup({
  on_attach = function(buffer) end,
})

vim.keymap.set("n", "]h", function()
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
end, { expr = true, desc = "Hunk forward" })

vim.keymap.set("n", "[h", function()
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
end, { expr = true, desc = "Hunk backward" })

-- hunk text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>")
