--- Personal collection of commonly used functions
---@class Hosaka
---@field keymap hosaka.keymap
---@field toggle hosaka.toggle
local Hosaka = {}
local H = {}

setmetatable(Hosaka, {
  __index = function(t, k)
    t[k] = require("hosaka." .. k)
    return t[k]
  end,
})

--- Hosaka setup
---@param config hosaka.Config
function Hosaka.setup(config)
  _G.HosakaTest = Hosaka

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

---

return Hosaka
