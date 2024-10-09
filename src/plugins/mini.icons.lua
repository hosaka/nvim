local miniicons = require("mini.icons")
miniicons.setup({
  -- ignore some extensions and rely on `vim.filetype.match()` fallback
  use_file_extension = function(ext, _)
    local suf3, suf4 = ext:sub(-3), ext:sub(-4)
    return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
  end,
})
miniicons.mock_nvim_web_devicons()
-- note: enable if using mini.completion
-- later(miniicons.tweak_lsp_kind)
