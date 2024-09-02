local function augroup(name)
  return vim.api.nvim_create_augroup("hosaka_" .. name, { clear = true })
end

-- check if file needs to be reloaded when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd([[checktime]])
    end
  end,
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
    "Avante",
    "AvanteInput",
    "PlenaryTestPopup",
    "checkhealh",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit buffer" })
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

-- change the border on MiniFiles buffers
vim.api.nvim_create_autocmd("User", {
  group = augroup("mini_files_border"),
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
  end,
})

-- apply lsp rename after MiniFiles renamed a fiile
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(args)
    Hosaka.lsp.rename(args.data.from, args.data.to)
  end,
})

-- terminal statusline
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_statusline"),
  pattern = { "term://*" },
  callback = function(event)
    local ministatus = require("mini.statusline")
    vim.b.ministatusline_config = {
      content = {
        active = function()
          local mode, mode_hl = ministatus.section_mode({ trunc_width = 120 })
          local term_title = tostring(vim.api.nvim_buf_get_var(event.buf, "term_title"))
          local term_number = tostring(vim.api.nvim_buf_get_var(event.buf, "toggle_number"))

          local term_proc = vim.split(vim.split(term_title, ";")[1], ":")

          return ministatus.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { term_number } },
            "%<", -- truncate point
            { hl = "MiniStatuslineFilename", strings = { term_proc[#term_proc] } },
            "%=", -- left alignment
          })
        end,
      },
    }
    -- local map = function(mode, key, cmd, opts)
    --   opts = opts or {}
    --   if opts.silent == nil then
    --     opts.silent = true
    --   end
    --   opts.buffer = event.buf
    --   vim.keymap.set(mode, key, cmd, opts)
    -- end
    -- map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Normal mode" })
    -- map("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Normal mode window" })
    -- map("t", "<C-h>", [[<cmd>wincmd h<cr>]], { desc = "Go to left window" })
    -- map("t", "<C-j>", [[<cmd>wincmd j<cr>]], { desc = "Go to lower window" })
    -- map("t", "<C-k>", [[<cmd>wincmd k<cr>]], { desc = "Go to upper window" })
    -- map("t", "<C-l>", [[<cmd>wincmd l<cr>]], { desc = "Go to right window" })
  end,
})
