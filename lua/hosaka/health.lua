local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function M.check()
  start("Version")

  M.neovim("0.9.4", "0.10")

  start("Tools")
  M.executable("git")

  start("Tools (optional)")
  M.executable("rg", "See https://github.com/BurntSushi/ripgrep")
  M.executable("lazygit", "See https://github.com/jesseduffield/lazygit")
  M.executable("lazydocker", "See https://github.com/jesseduffield/lazydocker")
end

---@private
---@param minimum string
---@param recommended string
function M.neovim(minimum, recommended)
  if vim.fn.has("nvim-" .. minimum) == 0 then
    error("neovim < " .. minimum)
  elseif vim.fn.has("nvim-" .. recommended) == 0 then
    warn("neovim < " .. recommended .. " some features will not work")
  else
    ok("neovim >= " .. recommended)
  end
end

---@private
---@param name string
---@param advice? string
function M.executable(name, advice)
  if vim.fn.executable(name) == 1 then
    -- local path = vim.fn.exepath(name)
    ok(name .. " installed")
  elseif advice == nil then
    error(name .. ": not installed")
  else
    warn(name .. ": not installed", advice)
  end
end

return M
