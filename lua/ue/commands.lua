local Ue = {}
local H = {}

Ue.setup = function(config)
  -- export module
  _G.UeCommands = Ue

  config = H.setup_config(config)

  H.apply_config(config)

  H.create_user_commands()
end

Ue.config = {
  engine = {
    path = nil,
  },
  targets = {
    -- todo: use the config table for target configuration
    {
      name = "Editor",
      configuration = "Development",
      platform = "Win64",
    },
  },
}

Ue.generate = function()
  H.notify("Generating clang database")

  if not H.setup_project() then
    H.notify("Could not find the root with the .uproject file", "ERROR")
    return
  end

  -- todo: prompt for a target from the Ue.config.targets

  local command = {
    H.project.ubt_path,
    "-Mode=GenerateClangDatabase",
    "-Project=" .. H.project.project_path,
    "-Game",
    "-Engine",
    "-Editor",
    H.project.project_name .. H.project.target.name,
    H.project.target.configuration,
    H.project.target.platform,
  }

  local on_done = vim.schedule_wrap(function(code, out, err)
    if code ~= 0 then
      H.notify("Failed to generate clang database", "ERROR")
      return
    end
    H.notify(out)
  end)

  H.cli_run(command, Ue.config.engine.path, on_done)
end

-- plugin data
H.default_config = Ue.config

H.project = {
  target = {
    name = "Editor",
    configuration = "Development",
    platform = "Win64",
  },
  ubt_path = nil,
  project_name = nil,
  project_path = nil,
}

-- plugin functions
H.setup_config = function(config)
  -- if props are not present in user config take them from the default config
  vim.validate({ config = { config, "table", true } })
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})
  vim.validate({
    engine = { config.engine, "table" },
  })
  vim.validate({
    ["engine.path"] = { config.engine.path, "string" },
  })
  return config
end

H.apply_config = function(config)
  Ue.config = config
end

H.create_user_commands = function()
  vim.api.nvim_create_user_command("UeGenerate", Ue.generate, { desc = "Generate UE clang database" })
end

H.setup_project = function()
  local cwd = vim.fn.getcwd()
  H.project.project_name, H.project.project_path = H.find_uproject(cwd)
  if not H.project.project_name then
    return false
  end

  H.notify(string.format("Using project %s", H.project.project_name))
  H.project.ubt_path = Ue.config.engine.path .. "/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool.exe"

  --get uproject path and dir
  -- local uproject_path, uproject_dir =
  return true
end

H.find_extension = function(path, extension)
  local dir = vim.loop.fs_opendir(path)
  if not dir then
    return nil
  end

  local handle = vim.loop.fs_scandir(path)
  while handle do
    local filename, _ = vim.loop.fs_scandir_next(handle)
    if not filename then
      break
    end
    if extension == vim.fn.fnamemodify(filename, ":e") then
      return H.full_path(path .. "/" .. filename)
    end
  end
  return nil
end

H.find_uproject = function(path)
  local parent_dir = vim.fn.fnamemodify(path, ":h")

  local uproject_path = H.find_extension(path, "uproject")
  if uproject_path then
    local project_name = vim.fn.fnamemodify(uproject_path, ":t:r")
    return project_name, uproject_path
  end

  -- todo: should probably the number of recursive traversals
  if path ~= parent_dir then
    return H.find_uproject(parent_dir)
  end

  return nil
end

H.cli_run = function(command, cwd, on_done)
  local executable, args = command[1], vim.list_slice(command, 2, #command)
  local process, stdout, stderr = nil, vim.uv.new_pipe(), vim.uv.new_pipe()
  local spawn_opts = { args = args, cwd = cwd or vim.fn.getcwd(), stdio = { nil, stdout, stderr } }

  -- allow on_done = nil to run the command synchronously
  local is_sync, result = false, nil
  if on_done == nil then
    is_sync = true
    on_done = function(code, out, err)
      result = { code = code, out = out, err = err }
    end
  end

  local out, err, is_done = {}, {}, false
  local on_exit = function(code)
    -- ensure this is called only once
    if is_done then
      return
    end
    is_done = true

    -- spawn has failed to start the process for whatever reason
    if not process then
      on_done(1)
      return
    end

    if process:is_closing() then
      return
    end
    process:close()

    -- convert streams to string for notify
    local outstring = H.cli_stream_tostring(out)
    local errstring = H.cli_stream_tostring(err)
    on_done(code, outstring, errstring)
  end

  -- process = vim.uv.spawn("rg", { args = {}, cwd = vim.fn.getcwd(), stdio = { nil, stdout, stderr } }, on_exit)
  process = vim.uv.spawn(executable, spawn_opts, on_exit)
  if not process then
    H.notify(string.format("Failed to start process, does %s exist?", executable), "ERROR")
    on_exit(1)
    return result
  end

  H.cli_read_stream(stdout, out)
  H.cli_read_stream(stderr, err)

  -- vim.defer_fn(function()
  --   if not process:is_active() then
  --     return
  --   end
  --   H.notify("Process reached timeout", "WARN")
  --   on_exit(1)
  -- end, 30000)

  if is_sync then
    vim.wait(30000, function()
      return is_done
    end, 1)
  end
  return result
end

H.cli_stream_tostring = function(stream)
  return (table.concat(stream):gsub("\n+$", ""))
end

H.cli_read_stream = function(stream, feed)
  local callback = function(err, data)
    if err then
      return table.insert(feed, 1, "ERROR: " .. err)
    end
    if data ~= nil then
      return table.insert(feed, data)
    end
    stream:close()
  end
  stream:read_start(callback)
end

H.full_path = function(path)
  return (vim.fn.fnamemodify(path, ":p"):gsub("\\", "/"):gsub("/+", "/"):gsub("(.)/$", "%1"))
end

H.notify = function(message, level)
  level = level or "INFO"
  if type(message) == "table" then
    message = table.concat(message, "\n")
  end
  vim.notify(string.format("(ue.nvim) %s", message), vim.log.levels[level])
  vim.cmd("redraw")
end

return Ue
