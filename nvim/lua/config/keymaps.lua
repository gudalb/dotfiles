vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

  -- Check if any other terminals are open
  local other_term_open = false
  for id, buf in pairs(terminal_buffers) do
    if id ~= term_id and vim.api.nvim_buf_is_valid(buf) then
      local wins = vim.fn.win_findbuf(buf)
      if #wins > 0 then
        other_term_open = true
        -- Focus the existing terminal window and split vertically from it
        vim.api.nvim_set_current_win(wins[1])
        vim.cmd 'rightbelow vsplit'
        break
      end
    end
  end

  if not other_term_open then
    -- First terminal, split horizontally at bottom
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