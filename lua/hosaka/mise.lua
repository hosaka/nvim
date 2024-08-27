local Mise = {}
local H = {}

--- Mise setup
---@param config MiseConfig|nil Config table. See |MiseConfig.config|.
---
---@usage >lua
---   require("mise").setup() -- use default config
---   -- OR
---   require("mise").setup({}) -- replace {} with your config table
--- <
Mise.setup = function(config)
  -- export module
  _G.Mise = Mise

  config = H.setup_config(config)

  H.apply_config(config)

  -- ensure executable
  H.has_mise = vim.fn.executable(config.cmd) == 1
  if not H.has_mise then
    H.notify(string.format("could not find %s executable", config.cmd), "WARN")
  end

  H.create_autocommands()

  H.create_user_commands()

  H.cache = {}

  if config.autoload then
    H.mise_reload_env()
  else
  end
end

---@class MiseConfig
Mise.config = {
  -- mise executable
  cmd = "mise",
  -- arguments to pass to mise when reading environment
  args = { "env", "--json" },
  -- load mise environment when setup() is called
  autoload = true,
  restore_path = vim.env.PATH,
}

H.default_config = Mise.config

H.cache = {}

H.has_mise = false

---@param config MiseConfig|nil
---@return MiseConfig
H.setup_config = function(config)
  -- combine user supplied config with default
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})
  return config
end

---@param config MiseConfig
H.apply_config = function(config)
  Mise.config = config
end

H.create_autocommands = function()
  local augroup = vim.api.nvim_create_augroup("Mise", {})
  local au = function(event, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = augroup, callback = callback, desc = desc })
  end
  au("DirChanged", function()
    if vim.v.event.scope == "global" then
      H.dir_changed()
    end
  end, "Load mise environment")
end

H.create_user_commands = function()
  vim.api.nvim_create_user_command("Mise", function()
    if not H.has_mise then
      H.notify(string.format("could not find %s executable", Mise.config.cmd), "WARN")
    end
    H.notify(vim.inspect(H.cache), "INFO")
  end, { desc = "Show mise environment" })
end

H.dir_changed = function()
  vim.env.PATH = Mise.config.restore_path
  H.mise_reload_env()
end

H.mise_reload_env = function()
  if not H.has_mise then
    return
  end

  local stdout = vim.loop.new_pipe()
  local spawn_opts = { args = Mise.config.args, cwd = vim.fn.getcwd(), stdio = { nil, stdout, nil } }
  local process, stdout_data = nil, nil

  local on_exit = function(code)
    process:close()
    if code ~= 0 or stdout_data == nil then
      H.error("oops")
      return
    end

    vim.schedule(function()
      local ok, decoded = pcall(vim.json.decode, stdout_data)
      if not ok or decoded == nil then
        H.error("invalid json returned from " .. Mise.config.cmd)
        return
      end

      -- unload cached
      for key, _ in pairs(H.cache) do
        if key ~= "PATH" then
          vim.env[key] = nil
        end
      end

      -- clear cached
      H.cache = {}

      -- load new
      for key, value in pairs(decoded) do
        vim.env[key] = value
        -- update cache
        H.cache[key] = value
      end
    end)
  end

  -- get mise env
  process = vim.loop.spawn(Mise.config.cmd, spawn_opts, on_exit)

  stdout:read_start(function(err, data)
    if err then
      H.error(Mise.config.cmd .. "returned an error " .. err)
      return
    end
    if data ~= nil then
      stdout_data = data
    end
    stdout:close()
  end)
end

---@param msg string
H.error = function(msg)
  vim.notify(string.format("(mise) %s", msg), vim.log.levels.ERROR)
end

---@param msg string
---@param level_name string
H.notify = function(msg, level_name)
  vim.notify(string.format("(mise) %s", msg), vim.log.levels[level_name])
end

return Mise
