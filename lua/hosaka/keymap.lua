--- Help with keymaps
---@class hosaka.keymap
local HosakaKeymap = {}

--- Map a key in normal mode or use `opts.mode`.
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
function HosakaKeymap.map(lhs, rhs, opts)
  opts = opts or {}
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Map a key with <Leader> prefix in normal mode or use `opts.mode`
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
function HosakaKeymap.mapl(lhs, rhs, opts)
  HosakaKeymap.map("<Leader>" .. lhs, rhs, opts)
end

--- Remap a key in a given mode
---@param lhs_from string
---@param lhs_to string
---@param opts? vim.keymap.set.Opts | { mode: string }
function HosakaKeymap.remap(lhs_from, lhs_to, opts)
  opts = opts or {}
  local mode = opts.mode or "n"
  opts.mode = nil
  local keymap = vim.fn.maparg(lhs_from, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  opts.desc = opts.desc or keymap.desc
  if rhs == nil then
    local msg = "Could not remap from " .. lhs_from .. " to " .. lhs_to
    vim.notify(string.format("(hosaka.keymap) %s", msg), vim.log.levels.ERROR)
  end
  vim.keymap.set(mode, lhs_to, rhs, opts)
end

return HosakaKeymap
