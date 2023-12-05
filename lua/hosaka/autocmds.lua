local function augroup(name)
  return vim.api.nvim_create_augroup("hosaka_" .. name, { clear = true })
end

-- check if file needs to be reloaded when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealh",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- don't auto wrap comments and don't insert comment leader after 'o'
-- this needs a FileType autocmd to persist
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_auto_comment"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "o" })
  end,
})
