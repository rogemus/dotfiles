require('fzf-lua').setup({
  files = {
    path_shorten = 6,
    formatter = 'path.filename_first',
    fd_opts = '--type f --color never --hidden --exclude .git',
  },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob !yarn.lock --glob !.yarn/* --glob !common/.yarn/* --glob !.git/*',
    git_icons = true,
    no_ignore = false,
    hidden = true,
  },
  buffers = {
    formatter = 'path.filename_first',
    sort_lastused = true,
    show_unlisted = false,
    cwd_only = true,
  },
  oldfiles = {
    formatter = 'path.filename_first',
  },
  fzf_opts = {
    ['--ansi'] = '',
    ['--prompt'] = '❯ ',
    ['--pointer'] = '▶',
    ['--marker'] = '✓',
    ['--info'] = 'inline',
  },
})

-- Keymaps
vim.keymap.set('n', '=', '<cmd>FzfLua buffers<cr>', { desc = 'Open files' })
vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep in files (Find in Files)' })
vim.keymap.set('n', '-', '<cmd>FzfLua files<cr>', { desc = 'Find File' })
vim.keymap.set('n', '0', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua grep_curbuf<cr>', { desc = 'Find in current file' })
vim.keymap.set('n', '<leader>m', '<cmd>FzfLua marks<cr>', { desc = 'Marks' })
vim.keymap.set('n', '<leader>td', function()
  require('fzf-lua').grep({ search = 'TODO|HACK|PERF|NOTE|FIX|FIXMEs', no_esc = true })
end, { desc = 'List todos' })
