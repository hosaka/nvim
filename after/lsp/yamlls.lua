return {
  on_attach = function(client, buffer)
    --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
    --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
    --- autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    yaml = {
      format = { enable = true },
      keyOrdering = false,
      -- disable built-in schema store in favour of schemastore
      schemaStore = { enable = false, url = "" },
      -- schemas = require("schemastore").yaml.schemas(),
    },
    redhat = { telemetry = { enabled = false } },
  },
}
