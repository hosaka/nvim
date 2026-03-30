return {
  settings = {
    yaml = {
      format = { enable = true },
      keyOrdering = false,
      -- disable built-in schema store in favour of schemastore
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
    redhat = { telemetry = { enabled = false } },
  },
}
