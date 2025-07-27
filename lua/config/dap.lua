-- lua/config/dap.lua

-- Setup Mason DAP (automated debug adapter installation)
require("mason-nvim-dap").setup({
  ensure_installed = { "cppdbg", "debugpy", "node2" },
  automatic_installation = true,
})

-- Setup nvim-dap-ui
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Optional: automatically open/close dap-ui when debugging starts/stops
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
