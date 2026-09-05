-- sindrets/diffview.nvim — GitHub / VSCode-style git diff review.
--
-- gitsigns (enabled in init.lua) covers the in-editor layer: gutter signs,
-- inline hunk previews, word-level diffs. diffview adds the other half — a
-- single tabpage with a file panel listing every changed file alongside
-- full side-by-side diffs, the way a GitHub PR review or VSCode's Source
-- Control diff editor works.
--
-- Common entry points:
--   :DiffviewOpen              review the working tree vs index/HEAD
--   :DiffviewOpen main..HEAD   review a branch/PR range
--   :DiffviewFileHistory %     browse the current file's history
--   :DiffviewFileHistory       browse the whole repo's history
--   :DiffviewClose             close the review tab
-- Inside the view: <tab>/<s-tab> cycle files, and it doubles as a 3-way
-- merge-conflict resolver during a merge/rebase.

vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {}

-- Label the <leader>g group in which-key (no-op if which-key isn't ready yet).
pcall(function()
  require('which-key').add { { '<leader>g', group = '[G]it diff (Diffview)' } }
end)

local map = vim.keymap.set
map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview: open (working tree)' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Diffview: file [h]istory (current file)' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Diffview: file [H]istory (repo)' })
map('n', '<leader>gc', '<cmd>DiffviewClose<cr>', { desc = 'Diffview: [c]lose' })
