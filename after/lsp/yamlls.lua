return {
  on_attach = function(client, buffer)
    if vim.fn.has("nvim-0.10") == 0 then
      client.server_capabilities.documentFormattingProvider = true
    end
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
