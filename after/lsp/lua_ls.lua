local filter_line_locations = function(locations)
  local present, res = {}, {}
  for _, loc in ipairs(locations) do
    local target = present[loc.filename] or {}
    if not target[loc.lnum] then
      table.insert(res, loc)
      target[loc.lnum] = true
    end
    present[loc.filename] = target
  end
  return res
end

local show_location = function(location)
  local buffer = location.buffer or vim.fn.bufadd(location.filename)
  vim.bo[buffer].buflisted = true
  vim.api.nvim_win_set_buf(0, buffer)
  vim.api.nvim_win_set_cursor(0, { location.lnum, location.col - 1 })
  vim.cmd([[normal! zv]])
end

local luals_on_list = function(args)
  local items = filter_line_locations(args.items)
  if #items > 1 then
    vim.fn.setqflist({}, " ", { title = "LSP locations", items = items })
    return vim.cmd([[copen]])
  end
  show_location(items[1])
end

return {
  on_attach = function(client, buffer)
    -- note: don't open quickfix list in case of multiple definitions
    -- luals treats `local x = function() end` as two definitions of `x`
    -- to work around this, override `gd` keymap with a buffer-local function
    if client:supports_method("textDocument/definition") then
      Hosaka.keymap.map("gd", function()
        return vim.lsp.buf.definition({ on_list = luals_on_list })
      end, { buffer = buffer, desc = "Go to Lua definition" })
    end
  end,
  capabilities = {},
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
      diagnostics = {
        -- common globals
        globals = { "vim" },
        -- disables workspace diagnostics
        workspaceDelay = -1,
        -- noisy missing-fields warnings
        disable = { "missing-fields" },
      },
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = false,
      },
    },
  },
}
