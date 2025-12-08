local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = "/home/alex/.local/share/mise/installs/node/20.16.0/bin/vue-language-server",
  languages = { "vue" },
  configNamespace = "typescript",
}

return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}
