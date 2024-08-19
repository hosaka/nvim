---@class Hosaka
---@field lsp HosakaLsp
---@field toggle HosakaToggle
local Hosaka = {}
local H = {}

Hosaka.new_scratch_buffer = function()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buffer)
  return buffer
end

---@param lhs string
---@param rhs (string | fun())
---@param desc string
Hosaka.nmap = function(lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("n", lhs, rhs, opts)
end

H.map_leader = function(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, "<Leader>" .. suffix, rhs, opts)
end

Hosaka.nmap_leader = function(suffix, rhs, desc, opts)
  H.map_leader("n", suffix, rhs, desc, opts)
end

Hosaka.xmap_leader = function(suffix, rhs, desc, opts)
  H.map_leader("x", suffix, rhs, desc, opts)
end

---@class HosakaToggle
Hosaka.toggle = {}

---@class Toggle
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)

---@class ToggleWrap: Toggle
---@operator call:boolean

---@param toggle Toggle
H.wrap = function(toggle)
  return setmetatable(toggle, {
    __call = function()
      toggle.set(not toggle.get())
      local state = toggle.get()
      if state then
        vim.notify("Toggle " .. toggle.name .. " on")
      else
        vim.notify("Toggle " .. toggle.name .. " off")
      end
      return state
    end,
  }) --[[@as ToggleWrap]]
end

---@param lhs string
---@param toggle Toggle
H.clue = function(lhs, toggle)
  -- todo: check if has("mini.clue")
  require("mini.clue").set_mapping_desc(
    "n",
    "<Leader>" .. lhs,
    "Toggle " .. toggle.name .. (toggle.get() and " off" or " on")
  )
end

---@param lhs string
---@param toggle Toggle
Hosaka.toggle.map = function(lhs, toggle)
  local t = H.wrap(toggle)
  Hosaka.nmap_leader(lhs, function()
    t()
    H.clue(lhs, t)
  end, "Toggle " .. toggle.name)
  H.clue(lhs, t)
end

---@param option string
---@param opts? {values?: {[1]:any, [2]:any}, name?: string}
H.option = function(option, opts)
  opts = opts or {}
  local name = opts.name or option
  local on = opts.values and opts.values[2] or true
  local off = opts.values and opts.values[1] or false
  return H.wrap({
    name = name,
    get = function()
      return vim.opt_local[option]:get() == on
    end,
    set = function(state)
      vim.opt_local[option] = state and on or off
    end,
  })
end

---@param lhs string
---@param option string
---@param opts? {values?: {[1]:any, [2]:any}, name?: string}
Hosaka.toggle.map_option = function(lhs, option, opts)
  local o = H.option(option, opts)
  Hosaka.nmap_leader(lhs, function()
    o()
    H.clue(lhs, o)
  end, "Toggle " .. option)
  H.clue(lhs, o)
end

---@class HosakaLsp
Hosaka.lsp = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function H.get_lsp_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

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
  local clients = H.get_lsp_clients()
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

-- export module
_G.Hosaka = Hosaka

return Hosaka
