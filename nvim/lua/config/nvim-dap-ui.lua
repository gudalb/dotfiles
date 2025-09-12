local dap, dapui = require 'dap', require 'dapui'

dapui.setup {
  expand_lines = true,
  controls = { enabled = false }, -- no extra play/step buttons
  floating = { border = 'rounded' },
  -- Set dapui window
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },
  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 1.0 }, -- 100% of this panel is scopes
      },
      size = 15, -- height in lines (adjust to taste)
      position = 'bottom', -- "left", "right", "top", "bottom"
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

vim.api.nvim_set_hl(0, 'blue', { fg = '#3d59a1' })
vim.api.nvim_set_hl(0, 'green', { fg = '#9ece6a' })
vim.api.nvim_set_hl(0, 'yellow', { fg = '#FFFF00' })
vim.api.nvim_set_hl(0, 'orange', { fg = '#f09000' })

vim.fn.sign_define('DapBreakpoint', {
  text = '⚪',
  texthl = 'DapBreakpointSymbol',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint',
})

vim.fn.sign_define('DapStopped', {
  text = '🔴',
  texthl = 'yellow',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointRejected', {
  text = '⭕',
  texthl = 'DapStoppedSymbol',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint',
})
