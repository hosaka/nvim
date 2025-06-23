return {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  settings = {
    json = {
      format = { enable = true },
      validate = { enable = true },
      -- schemas = require("schemastore").yaml.schemas(),
    },
  },
}
