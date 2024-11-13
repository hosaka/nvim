--- Collection of commonly used personal functions
---@class Hosaka
---@field lsp HosakaLsp
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
