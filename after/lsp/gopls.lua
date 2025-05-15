return {
  on_attach = function(client, buffer)
    -- workaround for gopls not supporting semanticTokensProvider
    -- see https://github.com/golang/go/issues/54531#issuecomment-1464982242
    if not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = {
          tokenTypes = semantic.tokenTypes,
          tokenModifiers = semantic.tokenModifiers,
        },
        range = true,
      }
    end
  end,
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      directoryFilters = { "-.git", "-.node_modules", "-.vscode", "-.idea" },
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
