local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
require('nvim-dap-virtual-text').setup()

vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })


dap.adapters.python = {
  type = 'executable',
  command = '/usr/bin/python3', -- Якщо у тебе віртуальне середовище, вкажи шлях до Python
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Запустити поточний файл",
    program = "${file}", -- Запускатиме активний файл
    pythonPath = function()
      return '/usr/bin/python3' -- Заміни на `venv/bin/python`, якщо використовуєш віртуальне середовище
    end,
  },
}

-- Debugger
vim.api.nvim_set_keymap("n", "<leader>dt", ":DapUiToggle<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>ht", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", {noremap=true})
