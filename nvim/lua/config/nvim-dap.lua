local dap = require 'dap'

local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/netcoredbg'

local netcoredbg_adapter = {
  type = 'executable',
  command = mason_path,
  args = { '--interpreter=vscode' },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

local dotnet = require 'config.nvim-dap-dotnet'

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return dotnet.build_dll_path()
    end,
  },
}
