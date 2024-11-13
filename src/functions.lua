--- Collection of commonly used personal functions
---@class Hosaka
---@field lsp HosakaLsp
---@field toggle HosakaToggle
local Hosaka = {}
local H = {}

--- Default personal augroup
---@param name string
Hosaka.augroup = function(name)
  return vim.api.nvim_create_augroup("hosaka_" .. name, { clear = true })
end

--- Make a new scratch buffer and switch to it
Hosaka.new_scratch_buffer = function()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buffer)
  return buffer
end

--- Map a key in normal mode
---@param lhs string
---@param rhs string|function
---@param desc string
---@param opts? vim.keymap.set.Opts
Hosaka.nmap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("n", lhs, rhs, opts)
end

--- Remap a key in a given mode
---@param mode string
---@param lhs_from string
---@param lhs_to string
---@param desc? string
Hosaka.remap = function(mode, lhs_from, lhs_to, desc)
  local keymap = vim.fn.maparg(lhs_from, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  if rhs == nil then
    error("Could not remap from " .. lhs_from .. " to " .. lhs_to)
  end
  vim.keymap.set(mode, lhs_to, rhs, { desc = desc or keymap.desc })
end

--- Map a key with <Leader> prefix in a given mode
---@param mode string|string[]
---@param suffix string
---@param rhs string|function
---@param desc string
---@param opts? vim.keymap.set.Opts
H.map_leader = function(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, "<Leader>" .. suffix, rhs, opts)
end

--- Map a key with <Leader> prefix in normal mode
---@param suffix string
---@param rhs string|function
---@param desc string
---@param opts? vim.keymap.set.Opts
Hosaka.nmap_leader = function(suffix, rhs, desc, opts)
  H.map_leader("n", suffix, rhs, desc, opts)
end

--- Map a key with <Leader> prefix in visual mode
---@param suffix string
---@param rhs string|function
---@param desc string
---@param opts? vim.keymap.set.Opts
Hosaka.xmap_leader = function(suffix, rhs, desc, opts)
  H.map_leader("x", suffix, rhs, desc, opts)
end

--- Help with options and custom toggle mappings
---@class HosakaToggle
Hosaka.toggle = {}

---@class Toggle
---@field name string
---@field on_name? string
---@field off_name? string
---@field get fun():boolean
---@field set fun(state:boolean)

---@class ToggleWrap: Toggle
---@operator call:boolean

---@param toggle Toggle
---@return ToggleWrap
H.wrap = function(toggle)
  return setmetatable(toggle, {
    __call = function()
      toggle.set(not toggle.get())
      local state = toggle.get()
      local on_name = toggle.on_name or "on"
      local off_name = toggle.off_name or "off"
      if state then
        vim.notify("Toggle " .. toggle.name .. " " .. on_name)
      else
        vim.notify("Toggle " .. toggle.name .. " " .. off_name)
      end
      return state
    end,
  }) --[[@as ToggleWrap]]
end

---@param lhs string
---@param toggle Toggle
H.set_toggle_desc = function(lhs, toggle)
  local on_name = toggle.on_name or "on"
  local off_name = toggle.off_name or "off"
  require("mini.clue").set_mapping_desc(
    "n",
    "<Leader>" .. lhs,
    "Toggle " .. toggle.name .. " " .. (toggle.get() and off_name or on_name)
  )
end

---@param lhs string
---@param toggle ToggleWrap
---@param opts? vim.keymap.set.Opts
H.nmap_toggle = function(lhs, toggle, opts)
  Hosaka.nmap_leader(lhs, function()
    toggle()
    H.set_toggle_desc(lhs, toggle)
  end, "Toggle " .. toggle.name, opts)
  H.set_toggle_desc(lhs, toggle)
end

--- Map a custom toggle in normal mode
---@param lhs string
---@param toggle Toggle
---@param opts? vim.keymap.set.Opts
Hosaka.toggle.map = function(lhs, toggle, opts)
  local wrapped = H.wrap(toggle)
  H.nmap_toggle(lhs, wrapped, opts)
end

--- Map a vim option toggle in normal mode
---@param lhs string
---@param option string
---@param opts? {name?: string, values?: {[1]:any, [2]:any}, is_global: boolean}
Hosaka.toggle.option = function(lhs, option, opts)
  opts = opts or {}
  local name = opts.name or option
  local on = opts.values and opts.values[1] or true
  local off = opts.values and opts.values[2] or false
  local is_global = opts.is_global or false
  local wrapped = H.wrap({
    name = name,
    get = function()
      if is_global then
        return vim.opt[option]:get() == on
      else
        return vim.opt_local[option]:get() == on
      end
    end,
    set = function(state)
      if is_global then
        vim.opt[option] = state and on or off
      else
        vim.opt_local[option] = state and on or off
      end
    end,
  })

  if opts.values then
    wrapped.on_name = opts.values[1]
    wrapped.off_name = opts.values[2]
  end
  H.nmap_toggle(lhs, wrapped)
end

--- Helps with frequently used LSP features
---@class HosakaLsp
Hosaka.lsp = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

--- Trigger LSP rename on clients that support it
---@param from string
---@param to string
function Hosaka.lsp.rename(from, to)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  ---@diagnostic disable-next-line: deprecated
  local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

--- Global module
_G.Hosaka = Hosaka

return Hosaka
