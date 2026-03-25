local map = Hosaka.keymap.map
local mapl = Hosaka.keymap.mapl

--- LSP keybind.
---@class LspKeybind
---@field mapper hosaka.keymap.Mapper
---@field lhs string Binding LHS
---@field rhs string|function Binding RHS
---@field opts? hosaka.keymap.MapOpts

--- Toggle LSP keybind. Default description is "Toggle `name`".
---@class LspToggleKeybind
---@field toggle boolean Marker to identify toggle bindings
---@field lhs string Binding LHS
---@field name string Toggle name
---@field get fun(buffer: integer):fun() Passed current LSP buffer to create a getter
---@field set fun(buffer: integer):fun(state: boolean) Passed current LSP buffer to create a setter
---@field opts? hosaka.keymap.MapOpts

--- Key bindings to be created on `LspAttach` and removed on `LspDetach`.
--- Entries can contain:
--- - A string key corresponding to an LSP capability (e.g "textDocument/definition"), containing
---   bindings that are only applied if the LSP client supports that method.
---@type table<vim.lsp.protocol.Method.ClientToServer | vim.lsp.protocol.Method.Registration, (LspKeybind|LspToggleKeybind)[]>
local bindings = {
  ["textDocument/hover"] = {
    { mapper = map, lhs = "K", rhs = "<cmd>lua vim.lsp.buf.hover()<cr>", opts = { desc = "Hover popup" } },
  },
  ["textDocument/definition"] = {
    { mapper = map, lhs = "gd", rhs = "<cmd>lua vim.lsp.buf.definition()<cr>", opts = { desc = "Go to definition" } },
  },
  ["textDocument/declaration"] = {
    {
      mapper = map,
      lhs = "gD",
      rhs = "<cmd>lua vim.lsp.buf.declaration()<cr>",
      opts = { desc = "Go to declaration" },
    },
  },
  ["textDocument/implementation"] = {
    {
      mapper = map,
      lhs = "gI",
      rhs = "<cmd>lua vim.lsp.buf.implementation()<cr>",
      opts = { desc = "Go to implementation" },
    },
  },
  ["textDocument/typeDefinition"] = {
    {
      mapper = map,
      lhs = "gY",
      rhs = "<cmd>lua vim.lsp.buf.type_definition()<cr>",
      opts = { desc = "Go to type definition" },
    },
  },
  ["textDocument/signatureHelp"] = {
    {
      mapper = map,
      lhs = "gK",
      rhs = "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      opts = { desc = "Signature help" },
    },
    {
      mapper = map,
      lhs = "<C-k>",
      rhs = "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      opts = { desc = "Signature help", mode = "i" },
    },
  },
  -- ["textDocument/documentHighlight"] = {
  --   mapper = mapl,
  --   lhs = "ch",
  --   rhs = "<cmd>lua vim.lsp.buf.document_highlight()<cr>",
  --   rhs = "<cmd>lua vim.lsp.buf.clear_references()<cr>",
  --   opts = { desc = "Highlight symbol" }
  -- },
  ["textDocument/codeAction"] = {
    {
      mapper = mapl,
      lhs = "ca",
      rhs = "<cmd>lua vim.lsp.buf.code_action()<cr>",
      opts = { desc = "Action", mode = { "n", "x" } },
    },
  },
  ["textDocument/rename"] = {
    { mapper = mapl, lhs = "cr", rhs = "<cmd>lua vim.lsp.buf.rename()<cr>", opts = { desc = "Rename symbol" } },
  },
  ["textDocument/references"] = {
    { mapper = mapl, lhs = "cR", rhs = "<cmd>lua vim.lsp.buf.references()<cr>", opts = { desc = "Find references" } },
  },
  -- fixme: this should be behind textDocument/publishDiagnostics capability
  -- in nvim 0.12 nightlies, the LSP client:supports_method() no longer accepts this capability and
  -- always returns false, preventing us from adding these bindings, this will likely have a solution
  -- in the stable 0.12 release
  ["textDocument/hover"] = {
    {
      mapper = mapl,
      lhs = "cd",
      rhs = "<cmd>lua vim.diagnostic.open_float()<cr>",
      opts = { desc = "Diagnostic popup" },
    },
    {
      mapper = mapl,
      lhs = "cD",
      rhs = function()
        vim.diagnostic.setqflist()
        -- expand source lines in quickfix items
        require("quicker").refresh()
      end,
      opts = { desc = "Diagnostic quickfix" },
    },
    {
      toggle = true,
      lhs = "od",
      name = "line diagnostics",
      get = function(buffer)
        -- note: assuming using lsp_lines plugin
        return function()
          return not vim.diagnostic.config().virtual_lines
        end
      end,
      set = function(buffer)
        return function(state)
          vim.diagnostic.config({ virtual_text = state, virtual_lines = not state })
        end
      end,
    },
  },
  ["textDocument/inlayHint"] = {
    {
      toggle = true,
      lhs = "oh",
      name = "inlay hints",
      get = function(buffer)
        return function()
          return vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
        end
      end,
      set = function(buffer)
        return function(state)
          vim.lsp.inlay_hint.enable(state, { bufnr = buffer })
        end
      end,
    },
  },
}

-- Default attach for all lsp servers
vim.api.nvim_create_autocmd("LspAttach", {
  group = Hosaka.augroup("lsp_attach"),
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client == nil then
      return
    end

    -- use mini.completion
    -- vim.bo[buffer].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

    -- use folding if available
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    -- create keybindings
    for capability, binding in pairs(bindings) do
      if client:supports_method(capability) then
        for _, keybind in ipairs(binding) do
          local opts = keybind.opts or {}
          opts.buf = buffer

          if keybind.toggle then
            Hosaka.toggle({
              name = keybind.name,
              get = keybind.get(buffer),
              set = keybind.set(buffer),
            }):mapl(keybind.lhs, opts)
          else
            keybind.mapper(keybind.lhs, keybind.rhs, opts)
          end
        end
      end
    end
  end,
})

-- todo: unmap bindings
-- vim.api.nvim_create_autocmd("LspDetach", {
--   group = Hosaka.augroup("lsp_detach"),
--   callback = function(event)
--     local buffer = event.buf
--     local client = vim.lsp.get_client_by_id(event.data.client_id)
--   end,
-- })
