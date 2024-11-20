--- Helps with frequently used LSP features
---@class hosaka.lsp
local HosakaLsp = {}

local H = {
  uv = vim.uv or vim.loop,
}

---@param path string
---@return string
function H.realpath(path)
  return vim.fs.normalize(H.uv.fs_realpath(path) or path)
end

--@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

--- Trigger LSP rename on clients that support it
---@param from string
---@param to string
---@param callback? fun()
function HosakaLsp.rename(from, to, callback)
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
  if callback then
    callback()
  end
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

--- Rename a file with user input and trigger LSP rename
function HosakaLsp.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local old = assert(H.realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(H.realpath(H.uv.cwd() or "."))

  if old:find(root, 1, true) ~= 1 then
    root = vim.fn.fnamemodify(old, ":p:h")
  end
  local current = old:sub(#root + 2)

  vim.ui.input({
    prompt = "New file name: ",
    default = current,
    completion = "file",
  }, function(new)
    if not new or new == "" or new == current then
      return
    end
    new = vim.fs.normalize(root .. "/" .. new)
    vim.fn.mkdir(vim.fs.dirname(new), "p")
    HosakaLsp.rename(old, new, function()
      vim.fn.rename(old, new)
      vim.cmd.edit(new)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
    end)
  end)
end

return HosakaLsp
