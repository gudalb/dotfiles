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
      local dll_path = dotnet.build_dll_path()
      if not dll_path then
        error("Failed to find DLL path")
      end
      if vim.fn.filereadable(dll_path) ~= 1 then
        error("DLL not found: " .. dll_path)
      end
      return dll_path
    end,
    cwd = function()
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
      return dotnet.find_project_root_by_csproj(current_dir)
    end,
    env = {
      ASPNETCORE_ENVIRONMENT = "Development",
      DOTNET_ENVIRONMENT = "Development",
    },
    stopAtEntry = true,
    console = 'integratedTerminal',
    justMyCode = false,
    requireExactSource = false,
    enableStepFiltering = false,
  },
}
