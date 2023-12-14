local tabclose = { "n", "<leader>q", [[<cmd>tabclose<cr>]], { desc = "Close Diffview" } }

require("diffview").setup({
  keymaps = {
    view = {
      tabclose
    },
    file_panel = {
      tabclose
    }
  }
})
