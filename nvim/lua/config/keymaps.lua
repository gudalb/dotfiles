-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open diagnostic float" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<C-q>", function()
  local current_buf = vim.api.nvim_get_current_buf()
  -- Switch to alternate buffer (last opened)
  vim.cmd("buffer #")
  -- Delete the previous buffer
  vim.api.nvim_buf_delete(current_buf, { force = false })
end, { desc = "Close buffer and go to last opened" })

-- debugging
local opts = { noremap = true, silent = true }

map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
map(
  "n",
  "<leader>dt",
  "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
  { noremap = true, silent = true, desc = "debug nearest test" }
)
vim.keymap.set("n", "<leader>dq", function()
  local dap = require("dap")

  if dap.session() then
    dap.terminate()
  end

  dap.close()

  local dapui_ok, dapui = pcall(require, "dapui")
  if dapui_ok then
    dapui.close()
  end

  print("All DAP instances terminated")
end, { desc = "Force quit all DAP instances" })
