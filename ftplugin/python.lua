vim.bo.formatprg = 'ruff format --stdin-filename ' .. vim.fn.expand('%:p') .. ' -'
