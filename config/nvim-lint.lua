require("lint").linters_by_ft = {
  sh = { "shellcheck" },
  dockerfile = { "hadolint" },
}

local debounce = function(ms, fn)
  local timer = vim.loop.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

local lint = function()
  require("lint").try_lint()
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = debounce(100, lint),
})
