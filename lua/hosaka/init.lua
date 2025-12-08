--- Collection of commonly used personal functions
---@class Hosaka
---@field keymap hosaka.keymap
---@field toggle hosaka.toggle
---@field lsp hosaka.lsp
local Hosaka = {}
local H = {}

setmetatable(Hosaka, {
  __index = function(t, k)
    t[k] = require("hosaka." .. k)
    return t[k]
  end,
})

--- Hosaka setup
---@param config? hosaka.Config
function Hosaka.setup(config)
  -- export module
  _G.Hosaka = Hosaka

  config = H.setup_config(config)

  H.apply_config(config)
end

---@class hosaka.Config
Hosaka.config = {}

H.default_config = Hosaka.config

---@param config? hosaka.Config
---@return hosaka.Config
function H.setup_config(config)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})
  return config
end

---@param config hosaka.Config
function H.apply_config(config)
  Hosaka.config = config
end

--- Default personal augroup
---@param name string
---@return integer
function Hosaka.augroup(name)
  return vim.api.nvim_create_augroup("hosaka_" .. name, { clear = true })
end

--- Make a new scratch buffer and switch to it
function Hosaka.new_scratch_buffer()
  local buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buffer)
  return buffer
end

function Hosaka.copy_relative_filepath()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify(path)
end

return Hosaka
