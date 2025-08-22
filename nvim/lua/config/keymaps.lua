vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { desc = 'Save file' })

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, desc = 'Close terminal' })
  end,
})

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

local terminal_buffers = {}

local function toggle_terminal(term_id)
  term_id = term_id or 1
  local term_buf = terminal_buffers[term_id]

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local term_wins = vim.fn.win_findbuf(term_buf)
    if #term_wins > 0 then
      vim.api.nvim_win_close(term_wins[1], false)
      return
    end
  end

  local other_term_open = false
  for id, buf in pairs(terminal_buffers) do
    if id ~= term_id and vim.api.nvim_buf_is_valid(buf) then
      local wins = vim.fn.win_findbuf(buf)
      if #wins > 0 then
        other_term_open = true
        vim.api.nvim_set_current_win(wins[1])
        vim.cmd 'rightbelow vsplit'
        break
      end
    end
  end

  if not other_term_open then
    vim.cmd 'botright split'
    local win_height = math.floor(vim.o.lines * 0.2)
    vim.api.nvim_win_set_height(0, win_height)
  end

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd 'terminal'
    terminal_buffers[term_id] = vim.api.nvim_get_current_buf()
  end

  vim.cmd 'startinsert'
end

vim.keymap.set('n', '<leader>ft', function()
  toggle_terminal(vim.v.count > 0 and vim.v.count or 1)
end, { desc = 'Toggle terminal' })
vim.keymap.set('n', '<C-,>', function()
  toggle_terminal(vim.v.count > 0 and vim.v.count or 1)
end, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-,>', function()
  toggle_terminal(vim.v.count > 0 and vim.v.count or 1)
end, { desc = 'Toggle terminal' })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map('n', '<F6>', "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map('n', '<F9>', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map('n', '<leader>dd', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true, desc = '[D]ebug [D]oggle breakpoint' })
map('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", opts)
map('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", opts)
map('n', '<F8>', "<Cmd>lua require'dap'.step_out()<CR>", opts)
map('n', '<leader>dr', "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map('n', '<leader>dl', "<Cmd>lua require'dap'.run_last()<CR>", opts)
map('n', '<leader>dc', "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true, desc = '[D]ebug [C]ontinue' })
map('n', '<leader>dC', "<Cmd>lua require'dap'.clear_breakpoints()<CR>", { noremap = true, silent = true, desc = '[D]ebug [C]lear all breakpoints' })
map('n', '<leader>ds', "<Cmd>Neotest summary<CR>", { noremap = true, silent = true, desc = '[D]ebug test [S]ummary' })
map('n', '<leader>dt', "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { noremap = true, silent = true, desc = 'debug nearest test' })
vim.keymap.set('n', '<leader>dq', function()
  local dap = require 'dap'

  if dap.session() then
    dap.terminate()
  end

  dap.close()

  local dapui_ok, dapui = pcall(require, 'dapui')
  if dapui_ok then
    dapui.close()
  end

  print 'All DAP instances terminated'
end, { desc = 'Force quit all DAP instances' })

-- LSP keybindings
map('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[C]ode [R]ename' })
map('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
map('n', '<leader>gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
map('n', '<leader>gi', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
