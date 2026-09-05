-- coder/claudecode.nvim — selection-aware Claude Code IDE integration.
--
-- Implements the same WebSocket MCP protocol as the official VS Code / JetBrains
-- extensions: text you select in nvim is sent to Claude Code in real time. Uses
-- Neovim's built-in terminal (`provider = 'native'`) so no snacks.nvim dependency
-- is needed (kickstart uses mini.nvim, not snacks).
--
-- Auth is whatever your `claude` CLI is logged into.
--
-- The in-nvim terminal split (<leader>ac) auto-connects, so selection context is
-- frictionless. To drive Claude Code from a tmux pane instead, launch it with
-- `claude --ide` (or run `/ide` inside claude) — it discovers this nvim via the
-- ~/.claude/ide/*.lock file and selection context flows the same way.

vim.pack.add { 'https://github.com/coder/claudecode.nvim' }

require('claudecode').setup {
  terminal = {
    provider = 'native',
  },
}

-- Label the <leader>a group in which-key (no-op if which-key isn't ready yet).
pcall(function()
  require('which-key').add { { '<leader>a', group = '[A]I (Claude)' } }
end)

local map = vim.keymap.set
map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Claude Code: toggle' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Claude Code: focus' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Claude Code: continue last session' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Claude Code: resume (pick session)' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Claude Code: add current buffer as context' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Claude Code: send selection' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Claude Code: accept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Claude Code: deny diff' })

-- Shift/Ctrl/Option+Enter insert a newline instead of submitting. We write the
-- line-feed straight into the terminal job, so it bypasses tmux's global C-j
-- binding (vim-tmux-navigator) entirely. Whichever combo your terminal can
-- actually deliver fires; the rest are harmless no-ops.
--
-- <S-CR>/<C-CR> only reach nvim with extended keys on end-to-end — see the
-- `extended-keys` / `extkeys` lines in ~/.tmux.conf. <M-CR> needs iTerm2's
-- Left Option set to "Esc+" (Settings → Profiles → Keys → General).
local function term_newline()
  vim.api.nvim_chan_send(vim.b.terminal_job_id, '\n')
end
for _, lhs in ipairs { '<S-CR>', '<C-CR>', '<M-CR>' } do
  map('t', lhs, term_newline, { desc = 'Insert newline (no submit)' })
end
