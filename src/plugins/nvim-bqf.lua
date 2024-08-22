require("bqf").setup({
  preview = {
    border = "rounded",
    should_preview_cb = function(buffer, _)
      return vim.bo[buffer].filetype ~= "bigfile"
    end,
  },
  func_map = {
    split = "<C-s>",
    vsplit = "<C-v>",
  },
})
