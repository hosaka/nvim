require("bqf").setup({
  preview = {
    border = "rounded",
    should_preview_cb = function(buffer, _)
      local bufname = vim.api.nvim_buf_get_name(buffer)
      local fsize = vim.fn.getfsize(bufname)
      -- skip files over 100k
      if fsize > 100 * 1024 then
        return false
      end
      return true
    end,
  },
  func_map = {
    split = "<C-s>",
    vsplit = "<C-v>",
  },
})
