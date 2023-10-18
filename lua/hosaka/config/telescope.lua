require("telescope").setup(function()
  local actions = require("telescope.actions")
  return {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      -- open files in the first window that is an actual file
      get_selection_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            return win
          end
        end
        return 0
      end,
      mappings = {
        i = {
          ["<C-Down>"] = actions.cycle_history_next,
          ["<C-Up>"] = actions.cycle_history_prev,
          ["<C-f>"] = actions.preview_scrolling_down,
          ["<C-b>"] = actions.preview_scrolling_up,
        },
        n = {
          ["q"] = actions.close,
        },
      },
      path_display = function(_, path)
        local tail = require("telescope.utils").path_tail(path)
        return string.format("%s (%s)", tail, path:gsub(tail, ""))
      end,
      -- use mini.fuzzy sorter
      file_sorter = require("mini.fuzzy").get_telescope_sorter,
      generic_sorter = require("mini.fuzzy").get_telescope_sorter,
    },
  }
end)

-- Custom 'find files': using `git_files` in the first place in order to ignore
-- results from submodules. Original source:
-- https://github.com/nvim-telescope/telescope.nvim/issues/410#issuecomment-765656002
hosaka.telescope_project_files = function()
  local ok = pcall(require("telescope.builtin").git_files)
  if not ok then
    require("telescope.builtin").find_files({ follow = true, hidden = true })
  end
end
