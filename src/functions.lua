Hosaka.new_scratch_buffer = function()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buffer)
  return buffer
end

Hosaka.toggle_quickfix = function()
  local quickfix = vim.tbl_filter(function(win_id)
    return vim.fn.getwininfo(win_id)[1].quickfix == 1
  end, vim.api.nvim_tabpage_list_wins(0))
  local command = #quickfix == 0 and "copen" or "cclose"
  vim.cmd(command)
end

Hosaka.map_leader = function(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, "<Leader>" .. suffix, rhs, opts)
end

Hosaka.nmap_leader = function(suffix, rhs, desc, opts)
  Hosaka.map_leader("n", suffix, rhs, desc, opts)
end

Hosaka.xmap_leader = function(suffix, rhs, desc, opts)
  Hosaka.map_leader("x", suffix, rhs, desc, opts)
end

Hosaka.nmap_leader_desc = function(suffix, desc)
  local lhs = "<Leader>" .. suffix
  require("mini.clue").set_mapping_desc("n", lhs, desc)
end

Hosaka.diagnostic_is_enabled = function(buf_id)
  if vim.fn.has("nvim-0.10") == 1 then
    return vim.diagnostic.is_enabled({ bufnr = buf_id })
  elseif vim.fn.has("nvim-0.9") == 1 then
    return not vim.diagnostic.is_disabled(buf_id)
  end
end

Hosaka.nmap_toggle_diagnostic = function(suffix, desc)
  local buffer = vim.api.nvim_get_current_buf()
  local current = Hosaka.diagnostic_is_enabled(buffer)

  Hosaka.nmap_leader(suffix, function()
    local state = require("mini.basics").toggle_diagnostic()
    local next = true
    if state == "  diagnostic" then
      next = false
    end
    vim.notify(desc .. " " .. (next and "off" or "on"))
    Hosaka.nmap_leader_desc(suffix, desc .. " " .. (next and "on" or "off"))
  end, desc .. " " .. (current and "off" or "on"))
end

Hosaka.nmap_toggle_option = function(suffix, option, desc)
  Hosaka.nmap_leader(suffix, function()
    vim.opt[option] = not vim.opt[option]:get()
    local state = vim.opt[option]:get()
    vim.notify(desc .. " " .. (state and "on" or "off"))
    Hosaka.nmap_leader_desc(suffix, desc .. " " .. (state and "off" or "on"))
  end, desc .. " " .. (vim.opt[option]:get() and "off" or "on"))
end

Hosaka.nmap_toggle_global = function(suffix, option, desc)
  Hosaka.nmap_leader(suffix, function()
    vim.g[option] = not vim.g[option]
    local state = vim.g[option]
    vim.notify(desc .. " " .. (state and "off" or "on"))
    Hosaka.nmap_leader_desc(suffix, desc .. " " .. (state and "on" or "off"))
  end, desc .. " " .. (vim.g[option] and "on" or "off"))
end

Hosaka.nmap_toggle_states = function(suffix, option, on_state, off_state, desc)
  local next = on_state
  if vim.o[option] == on_state then
    next = off_state
  end

  Hosaka.nmap_leader(suffix, function()
    -- toggle
    if vim.o[option] == on_state then
      vim.o[option] = off_state
    else
      vim.o[option] = on_state
    end

    local next = vim.o[option]
    vim.notify(desc .. " " .. next)

    if vim.o[option] == on_state then
      next = off_state
    else
      next = on_state
    end
    Hosaka.nmap_leader_desc(suffix, desc .. " " .. next)
  end, desc .. " " .. next)
end
