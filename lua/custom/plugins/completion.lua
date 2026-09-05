-- minuet-ai.nvim — Claude-API-powered ghost-text completion (Cursor-style <Tab> autocomplete).
--
-- Reality check: Claude is a chat model, not a purpose-built fill-in-the-middle
-- model, so as-you-type suggestions are higher-latency than Copilot/Cursor's
-- engine. Haiku keeps it as fast as Claude gets; the throttle/debounce below pace
-- requests so it isn't firing on every keystroke. Swap the model to
-- 'claude-sonnet-4-6' for higher-quality (slower) suggestions.
--
-- Requires the ANTHROPIC_API_KEY environment variable to be set in your shell.
-- The HTTP layer (plenary.nvim) is already installed as a telescope dependency.
--
-- Ghost text is independent of blink.cmp's normal completion menu — this only
-- adds the inline suggestion + <Tab> accept; blink keeps <C-y> to accept its menu.

vim.pack.add { 'https://github.com/milanglacier/minuet-ai.nvim' }

require('minuet').setup {
  provider = 'claude',

  -- Pace requests — chat models are slower and chattier than FIM models.
  debounce = 400, -- ms of idle typing before a request fires
  throttle = 1000, -- ms minimum between requests
  request_timeout = 4, -- seconds before giving up on a suggestion

  provider_options = {
    claude = {
      model = 'claude-haiku-4-5', -- fastest Claude; 'claude-sonnet-4-6' for higher quality
      max_tokens = 256,
      stream = true,
      api_key = 'ANTHROPIC_API_KEY', -- name of the env var, NOT the key itself
    },
  },

  virtualtext = {
    -- Filetypes to auto-suggest in. Use { '*' } to enable everywhere.
    auto_trigger_ft = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'go',
      'rust',
      'c',
      'cpp',
      'java',
      'sh',
      'bash',
      'json',
      'yaml',
    },
    keymap = {
      accept = '<Tab>', -- accept the whole suggestion (falls through to a normal Tab when none is shown)
      accept_line = '<A-a>', -- accept just the next line
      accept_n_lines = '<A-z>',
      prev = '<A-[>',
      next = '<A-]>',
      dismiss = '<A-e>',
    },
  },
}
