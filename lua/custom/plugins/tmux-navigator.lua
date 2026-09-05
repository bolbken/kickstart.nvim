-- christoomey/vim-tmux-navigator — seamless Ctrl-h/j/k/l navigation that
-- crosses freely between nvim splits and tmux panes with the same keys.
--
-- The other half of this lives in ~/.tmux.conf, which detects whether the
-- focused pane is running nvim and either forwards Ctrl-h/j/k/l to it or moves
-- the tmux pane. Both halves must agree, so keep them in sync.
--
-- The plugin installs its default <C-h/j/k/l> normal-mode mappings on load;
-- no setup() call is required.

vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }
