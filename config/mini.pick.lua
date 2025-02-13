local minipick = require("mini.pick")

minipick.setup({
  mappings = {
    -- choosing marked items will send them to quickfix list
    choose_marked = "<C-q>",
  },
  window = {
    config = function()
      -- centered on screen
      local height = math.floor(0.618 * vim.o.lines)
      local width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = "NW",
        border = "rounded",
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
})
-- use as a default selector
vim.ui.select = minipick.ui_select

-- same as default buf_lines picker but with treesitter highlight preserved
local pick_buffer_lines = function(buffer, items, query, opts)
  if items == nil or #items == 0 or not items[1].bufnr then
    return
  end

  minipick.default_show(buffer, items, query, opts)

  local ns = vim.api.nvim_create_namespace("pick_buffer_syntax_highlight")
  vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

  -- assume all items come from the same buffer
  local bufnr = items[1].bufnr

  local filetype = vim.bo[bufnr].filetype
  local has_lang, lang = pcall(vim.treesitter.language.get_lang, filetype)
  if not has_lang then
    lang = filetype
  end

  -- parse the buffer to get the syntax tree
  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then
    vim.notify("Failed to get Treesitter parser for language: " .. lang, vim.log.levels.ERROR)
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()

  -- get the highlight query for the language
  local ts_query = vim.treesitter.query.get(lang, "highlights")
  if not ts_query then
    return
  end

  -- build a mapping from original line numbers to picker buffer line indices
  local line_num_to_picker_line = {}
  local prefix_lengths = {}

  local total_lines = vim.api.nvim_buf_line_count(buffer)
  for line = 1, total_lines do
    local display_line = vim.api.nvim_buf_get_lines(buffer, line - 1, line, false)[1] or ""

    -- match the line number prefix added by default_show
    local prefix_pattern = "^(%s*(%d+)%s*│)"
    local prefix_start, prefix_end, prefix, line_str = display_line:find(prefix_pattern)
    local prefix_length = prefix_end or 0
    local line_number = tonumber(line_str)
    if line_number then
      line_num_to_picker_line[line_number - 1] = line - 1
      prefix_lengths[line_number - 1] = prefix_length
    end
  end

  -- determine the range of lines to process
  local min_line, max_line = math.huge, -math.huge
  for line_number, _ in pairs(line_num_to_picker_line) do
    if line_number < min_line then
      min_line = line_number
    end
    if line_number > max_line then
      max_line = line_number
    end
  end

  if min_line == math.huge or max_line == -math.huge then
    return
  end

  local start_line = min_line
  local end_line = max_line + 1 -- end_line is exclusive

  -- todo: exclude the `query` from being highlighted, otherwise can't see the fuzzy matches

  -- iterate over all captures in range
  for id, node in ts_query:iter_captures(root, bufnr, start_line, end_line) do
    local hl = ts_query.captures[id] -- name of the capture
    if hl then
      local sr, sc, er, ec = node:range()

      -- apply highlights for each line the node spans
      for line = sr, er do
        local picker_line = line_num_to_picker_line[line]
        if picker_line then
          local prefix_length = prefix_lengths[line] or 0
          local start_col = (line == sr) and (sc + prefix_length) or prefix_length
          local end_col = (line == er) and (ec + prefix_length) or -1
          vim.api.nvim_buf_add_highlight(buffer, ns, "@" .. hl, picker_line, start_col, end_col)
        end
      end
    end
  end
end

minipick.registry.buf_lines_current = function()
  return require("mini.extra").pickers.buf_lines(
    { scope = "current", preserve_order = true },
    { source = { show = pick_buffer_lines } }
  )
end

minipick.registry.sessions = function()
  return require("mini.sessions").select()
end

minipick.registry.projects = function()
  local cwd = vim.fn.expand("~/wa")
  local choose = function(item)
    vim.schedule(function()
      MiniPick.builtin.files(nil, { source = { cwd = item.path } })
    end)
  end
  return require("mini.extra").pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
end

-- same as default buffers picker but with extra key mappings
local function pick_open_buffers()
  minipick.builtin.buffers(nil, {
    mappings = {
      delete_buffer = {
        char = "<C-d>",
        func = function()
          local matches = minipick.get_picker_matches()
          if matches then
            if next(matches.marked) then
              for _, buffer in ipairs(matches.marked) do
                vim.cmd.bdelete(buffer.bufnr)
              end
            elseif matches.current then
              -- vim.api.nvim_buf_delete()
              vim.cmd.bdelete(matches.current.bufnr)
            end
            -- fixme: restarting the picker refreshes the items, but perhaps
            -- there's a better way: removing deleted buffers from items
            pick_open_buffers()
          end
        end,
      },
    },
  })
end

minipick.registry.open_buffers = pick_open_buffers
