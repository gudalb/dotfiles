local dap, dapui = require 'dap', require 'dapui'

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
  mappings = {
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  element_mappings = {},
  expand_lines = vim.fn.has 'nvim-0.7' == 1,
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40, -- 40 columns
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 0.25, -- 25% of total lines
      position = 'bottom',
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = 'repl',
    icons = {
      pause = '',
      play = '',
      step_into = '',
      step_over = '',
      step_out = '',
      step_back = '',
      run_last = '↻',
      terminate = '□',
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = 'single', -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
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

  text = '🔴', -- nerdfonts icon here
  texthl = 'DapBreakpointSymbol',
  numhl = 'DapBreakpoint',
})

vim.fn.sign_define('DapStopped', {
  text = '', -- nerdfonts icon here
  texthl = 'yellow',
  numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointRejected', {
  text = '', -- nerdfonts icon here
  texthl = 'DapStoppedSymbol',
  numhl = 'DapBreakpoint',
})
