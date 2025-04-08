local dap, dapui = require("dap"), require("dapui")

-- note: DapStoppedLine is defined in tokyonight.nvim
local signs = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = { " ", "DiagnosticError" },
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

for name, sign in pairs(signs) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.zig = {
  {
    name = "Zig",
    type = "codelldb",
    request = "launch",
    program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

-- open and close dapui with dap events
-- dap.listeners.before.attach.dapui_config = function()
--   dapui.open()
-- end
-- dap.listeners.before.launch.dapui_config = function()
--   dapui.open()
-- end
dap.listeners.before.event_initialized.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

dapui.setup({
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.55,
        },
        {
          id = "watches",
          size = 0.20,
        },
        {
          id = "breakpoints",
          size = 0.15,
        },
        {
          id = "stacks",
          size = 0.15,
        },
      },
      position = "left",
      size = 50,
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5,
        },
        {
          id = "console",
          size = 0.5,
        },
      },
      position = "bottom",
      size = 9,
    },
  },
})
