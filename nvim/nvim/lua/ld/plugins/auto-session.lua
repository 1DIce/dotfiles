local session = require('auto-session')

session.setup({
  auto_session_suppress_dirs = {'~/'},
  auto_save_enabled = true,
  auto_restore_enabled = false
})
