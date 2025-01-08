-- defaults
local show_dotfiles = false
local augroup = Hosaka.augroup

local content_filter = function(fs_entry)
  local show = true
  if not show_dotfiles then
    show = not vim.startswith(fs_entry.name, ".")
  end
  return show
end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  MiniFiles.refresh({
    content = { filter = content_filter },
  })
end

local map_split = function(buf_id, lhs, direction, close_on_file)
  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd("belowright " .. direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    -- setting window as a target keeps mini.files open
    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in({ close_on_file = close_on_file })
  end

  local desc = "Open in " .. direction .. " split"
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

local set_cwd = function()
  local cur_entry_path = MiniFiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.notify(cur_directory)
  if cur_directory ~= nil then
    vim.fn.chdir(cur_directory)
  end
end

-- change the border
vim.api.nvim_create_autocmd("User", {
  group = augroup("mini_files_border"),
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
  end,
})

-- additional key mappings
vim.api.nvim_create_autocmd("User", {
  group = augroup("mini_files_extra_mappings"),
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- adding `desc` will show keymaps in the help popup (g?)
    vim.keymap.set(
      "n",
      "<CR>",
      [[<cmd>lua MiniFiles.go_in({ close_on_file = true})<cr>]],
      { buffer = buf_id, desc = "Open" }
    )
    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden" })
    vim.keymap.set("n", "gc", set_cwd, { buffer = buf_id, desc = "Set cwd" })
    map_split(buf_id, "<C-s>", "horizontal", false)
    map_split(buf_id, "<C-v>", "vertical", false)
    map_split(buf_id, "<C-w>s", "horizontal", true)
    map_split(buf_id, "<C-w>v", "vertical", true)
  end,
})

-- default bookmarks, summon with ' followed by the bookmark letter
vim.api.nvim_create_autocmd("User", {
  group = augroup("mini_files_default_bookmarks"),
  pattern = "MiniFilesExplorerOpen",
  callback = function()
    MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
    MiniFiles.set_bookmark("m", vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim", { desc = "mini.nvim" })
    MiniFiles.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/deps/opt", { desc = "Plugins" })
    MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
  end,
})

-- apply lsp rename after renaming a fiile
vim.api.nvim_create_autocmd("User", {
  group = augroup("mini_files_lsp_rename"),
  pattern = "MiniFilesActionRename",
  callback = function(args)
    Hosaka.lsp.rename(args.data.from, args.data.to)
  end,
})

require("mini.files").setup({
  content = {
    filter = content_filter,
  },
  windows = {
    preview = true,
    width_focus = 30,
    width_nofocus = 15,
    width_preview = 100,
  },
  options = {
    -- replacing netrw breaks nvim scp://user@host//path/to/file
    use_as_default_explorer = false,
  },
  mappings = {
    go_in = "L",
    go_in_plus = "l",
    go_out = "H",
    go_out_plus = "h",
    synchronize = "s",
  },
})
