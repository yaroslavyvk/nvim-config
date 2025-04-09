-- worktree settings
require('git-worktree').setup()

-- Python
local format_sync_grp = vim.api.nvim_create_augroup("PythonFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.cmd("silent! !black % && isort %")
  end,
  group = format_sync_grp,
})


-- Група для автоформатування YAML та Docker
local format_sync_grp = vim.api.nvim_create_augroup("AutoFormat", {})

-- Автоформатування YAML перед збереженням
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.yaml,*.yml",
  callback = function()
    vim.cmd("silent! !yamlfmt -w %")
  end,
  group = format_sync_grp,
})

-- Автоформатування Docker перед збереженням
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "Dockerfile,*.docker",
  callback = function()
    vim.cmd("silent! !dockfmt fmt %")
  end,
  group = format_sync_grp,
})
