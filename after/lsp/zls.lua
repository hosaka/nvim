return {
  settings = {
    zls = {
      -- neovim already provides basic syntax highlighting
      semantic_tokens = "partial",
      -- Build-On-Save only runs in projects whose build.zig defines a `check`
      -- step (as long as `enable_build_on_save` stays unset), so this only
      -- applies there. Don't set `enable_build_on_save` alongside -fincremental.
      -- https://zigtools.org/zls/guides/build-on-save/#incremental-compilation
      build_on_save_args = { "-fincremental" },
    },
  },
}
