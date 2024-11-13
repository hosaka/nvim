--- Help with options and custom toggle mappings
---@class hosaka.toggle
---@field opts hosaka.toggle.Opts
---@overload fun(... :hosaka.toggle.Opts): hosaka.toggle
local HosakaToggle = setmetatable({}, {
  __call = function(t, ...)
    return t.new(...)
  end,
})

local H = {}

---@class hosaka.toggle.Config
H.default_config = {
  -- map function to use
  map = vim.keymap.set,
  -- show a notification when toggling
  notify = true,
  -- integrate with mini.clue to show on/off state
  clue = true,
}

---@param keys string
---@param mode string | string[]
---@param toggle hosaka.toggle
function H:_clue(keys, mode, toggle)
  local on_name = toggle.opts.on_name or "on"
  local off_name = toggle.opts.off_name or "off"
  require("mini.clue").set_mapping_desc(
    mode,
    keys,
    "Toggle " .. toggle.opts.name .. " " .. (toggle:get() and off_name or on_name)
  )
end

---@param msg string
function H.error(msg)
  vim.notify(string.format("(hosaka.toggle) %s", msg), vim.log.levels.ERROR)
end

---@class hosaka.toggle.Opts: hosaka.toggle.Config
---@field name string
---@field on_name? string
---@field off_name? string
---@field get fun():boolean
---@field set fun(state:boolean)

--- New toggle
---@param ... hosaka.toggle.Opts
---@return hosaka.toggle
function HosakaToggle.new(...)
  local self = setmetatable({}, { __index = HosakaToggle })
  local merged = { vim.deepcopy(H.default_config) }
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    if v then
      table.insert(merged, vim.deepcopy(v))
    end
  end
  self.opts = vim.tbl_deep_extend("force", unpack(merged)) --[[@as hosaka.toggle.Opts]]
  return self
end

-- Get this toggle state
function HosakaToggle:get()
  local ok, ret = pcall(self.opts.get)
  if not ok then
    H.error("failed to get state for " .. self.opts.name .. ": " .. ret)
    return false
  end
  return ret
end

-- Set this toggle state
function HosakaToggle:set(state)
  local ok, err = pcall(self.opts.set, state) ---@type boolean, string?
  if not ok then
    H.error("failed to set state for " .. self.opts.name .. ": " .. err)
  end
end

-- Toggle this toggle
function HosakaToggle:toggle()
  self:set(not self:get())
  if self.opts.notify then
    local state = self:get()
    local on_name = self.opts.on_name or "on"
    local off_name = self.opts.off_name or "off"
    if state then
      vim.notify("Toggle " .. self.opts.name .. " " .. on_name)
    else
      vim.notify("Toggle " .. self.opts.name .. " " .. off_name)
    end
  end
end

--- New local option (vim.opt_local) toggle
---@param option string
---@param opts? hosaka.toggle.Opts | {on?: unknown, off?: unknown}
function HosakaToggle.option(option, opts)
  opts = opts or {}
  local on = opts.on == nil and true or opts.on
  local off = opts.off ~= nil and opts.off or false
  local toggle = HosakaToggle.new({
    name = option,
    get = function()
      -- if is_global then
      --   return vim.opt[option]:get() == on
      -- else
      -- end
      return vim.opt_local[option]:get() == on
    end,
    set = function(state)
      -- if is_global then
      --   vim.opt[option] = state and on or off
      -- else
      -- end
      vim.opt_local[option] = state and on or off
    end,
  }, opts)
  toggle.opts.on_name = opts.on ~= nil and opts.on or opts.on_name
  toggle.opts.off_name = opts.off ~= nil and opts.off or opts.off_name
  return toggle
end

--- New global option (vim.g) toggle
---@param option string
---@param opts? hosaka.toggle.Opts | {on?: unknown, off?: unknown}
function HosakaToggle.global(option, opts)
  return HosakaToggle.new({
    name = option,
    get = function()
      return not vim.g[option]
    end,
    set = function(state)
      vim.g[option] = not state
    end,
  }, opts)
end

--- Add a keymap to this toggle
---@param keys string
---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
function HosakaToggle:map(keys, opts)
  opts = opts or {}
  local mode = opts.mode or "n"
  opts.mode = nil
  opts.desc = opts.desc or ("Toggle " .. self.opts.name)

  self.opts.map(mode, keys, function()
    self:toggle()
    if self.opts.clue and pcall(require, "mini.clue") then
      H:_clue(keys, mode, self)
    end
  end, opts)
  if self.opts.clue and pcall(require, "mini.clue") then
    H:_clue(keys, mode, self)
  end
end

--- Map a toggle prefixed with <Leader>
---@param keys string
---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
function HosakaToggle:mapl(keys, opts)
  self:map("<Leader>" .. keys, opts)
end

return HosakaToggle
