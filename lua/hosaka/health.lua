local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function M.check()
  start("hosaka")

  if vim.fn.has("nvim-0.10") == 1 then
    ok("Using Neovim >= 0.10")
  else
    error("Neovim >= 0.10 is required")
  end

  for _, cmd in ipairs({ "git", "rg", "lazygit" }) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    local found = false

    ---@cast commands string[]
    for _, c in ipairs(commands) do
      if vim.fn.executable(c) then
        name = c
        found = true
      end
    end

    if found then
      ok(("`%s` is installed"):format(name))
    else
      warn(("`%s` is not installed"):format(name))
    end
  end
end

return M
