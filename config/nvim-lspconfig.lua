-- Default attach for all lsp servers
vim.api.nvim_create_autocmd("LspAttach", {
  group = Hosaka.augroup("lsp_attach"),
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(lhs, rhs, opts)
      opts.buffer = buffer
      Hosaka.keymap.map(lhs, rhs, opts)
    end
    local mapl = function(lhs, rhs, opts)
      opts.buffer = buffer
      Hosaka.keymap.mapl(lhs, rhs, opts)
    end
    local mapt = function(lhs, name, get, set)
      Hosaka.toggle({
        name = name,
        get = get,
        set = set,
      }):mapl(lhs, { buffer = buffer })
    end

    -- use mini.completion
    -- vim.bo[buffer].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

    -- use folding if available
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    map("K", [[<cmd>lua vim.lsp.buf.hover()<cr>]], { desc = "Hover popup" })

    if client:supports_method("textDocument/definition") then
      map("gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], { desc = "Go to definition" })
    end

    if client:supports_method("textDocument/declaration") then
      map("gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], { desc = "Go to declaration" })
    end

    if client:supports_method("textDocument/implementation") then
      map("gI", [[<cmd>lua vim.lsp.buf.implementation()<cr>]], { desc = "Go to implementation" })
    end

    if client:supports_method("textDocument/typeDefinition") then
      map("gY", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], { desc = "Go to type definition" })
    end

    if client:supports_method("textDocument/signatureHelp") then
      map("gK", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], { desc = "Signature help" })
      map("<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], { mode = "i", desc = "Signature help" })
    end

    if client:supports_method("textDocument/codeAction") then
      mapl("ca", [[<cmd>lua vim.lsp.buf.code_action()<cr>]], { mode = { "n", "x" }, desc = "Action popup" })
    end

    if client:supports_method("textDocument/rename") then
      mapl("cr", [[<cmd>lua vim.lsp.buf.rename()<cr>]], { desc = "Rename symbol" })
    end

    if client:supports_method("textDocument/references") then
      mapl("cR", [[<cmd>lua vim.lsp.buf.references()<cr>]], { desc = "Find references" })
    end

    if client:supports_method("textDocument/publishDiagnostics") then
      mapl("cd", [[<cmd>lua vim.diagnostic.open_float()<cr>]], { desc = "Diagnostic popup" })
      mapl("cD", function()
        vim.diagnostic.setqflist()
        -- expand source lines in for quickfix items
        require("quicker").refresh()
      end, { desc = "Diagnostic quickfix" })

      mapt("od", "diagnostics", function()
        return vim.diagnostic.is_enabled()
      end, function()
        require("mini.basics").toggle_diagnostic()
      end)

      -- note: assuming using lsp_lines plugin
      mapt("oD", "line diagnostics", function()
        return not vim.diagnostic.config().virtual_lines
      end, function(state)
        vim.diagnostic.config({ virtual_text = state, virtual_lines = not state })
      end)
    end

    if client:supports_method("textDocument/inlayHint") then
      if vim.lsp.inlay_hint then
        mapt("oh", "inlay hints", function()
          return vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
        end, function(state)
          vim.lsp.inlay_hint.enable(state, { bufnr = buffer })
        end)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = Hosaka.augroup("lsp_detach"),
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
  end,
})

-- Default LSP capabilities
---@param override? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
local default_capabilities = function(override)
  return require("blink.cmp").get_lsp_capabilities(override)
end

if vim.fn.has("nvim-0.11") == 0 then
  -- todo: fallback to nvim-lspconfig?
  return
end

-- all clients
vim.lsp.config("*", {
  capabilities = default_capabilities(),
})

vim.lsp.enable({
  "bashls",
  "clangd",
  "eslint",
  "gopls",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "ruff",
  "rust_analyzer",
  "solidity_ls_nomicfoundation",
  "taplo",
  "ts_ls",
  "yamlls",
  "zls",
})
