-- bootstrap mini.nvim manually so it gets managed by mini.deps
local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd([[echo "Installing `mini.nvim`" | redraw]])
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd([[packadd mini.nvim | helptags ALL]])
  vim.cmd([[echo "Installed `mini.nvim`" | redraw]])
end

-- global config table
_G.Config = {
  mini = {
    -- default path for mini.deps to save snapshots
    snapshot = vim.fn.stdpath("config") .. "/snapshot",
  },
}

-- setup mini.deps immediately to use in during plugin config
local deps = require("mini.deps")
deps.setup({
  path = {
    snapshot = Config.mini.snapshot,
  },
})

-- custom `now` or `later` helper
_G.Config.now_if_args = vim.fn.argc(-1) > 0 and deps.now or deps.later
