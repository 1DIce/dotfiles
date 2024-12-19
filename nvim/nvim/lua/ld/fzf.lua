local actions = require("fzf-lua.actions")

local function files(opts)
  opts = opts or {}
  return require("fzf-lua").files(opts)
end

-- Inherit from the "buffer_or_file" previewer
local WorkspaceTypesPreviewer = require("fzf-lua.previewer.builtin").buffer_or_file:extend()
function WorkspaceTypesPreviewer:new(o, opts, fzf_win)
  WorkspaceTypesPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, WorkspaceTypesPreviewer)
  return self
end
function WorkspaceTypesPreviewer:parse_entry(entry_str)
  -- Assume an arbitrary entry in the format of 'file:line'
  local parts = vim.fn.split(entry_str, "\t")
  local selected_file = parts[2]

  local file = require("fzf-lua").path.entry_to_file(selected_file)
  return file
end

---
---@param cmd string command to exectute external coding-flow tool
---@param opts any
---@return nil
local function workspace_coding_flow_symbols(cmd, opts)
  opts = opts or {}
  -- Currently only typescript files are supported
  return require("fzf-lua").fzf_exec(cmd, {
    prompt = opts.prompt,
    slient_fail = false,
    previewer = WorkspaceTypesPreviewer,
    winopts = {
      height = 0.90, -- window height
      width = 0.95, -- window width
      row = 0.35, -- window row position (0=top, 1=bottom)
      col = 0.50, -- window col position (0=left, 1=right)
    },
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--multi"] = "", -- activate multi selection
      ["--nth"] = "1", -- limit search to symbol names only
    },
    actions = {
      ["default"] = function(selected)
        if #selected == 1 then
          local parts = vim.fn.split(selected[1], "\t")
          local selected_file = parts[2]

          local file = require("fzf-lua").path.entry_to_file(selected_file)
          -- open file and go to cursor position afterwards
          vim.cmd("edit " .. file.path)
          pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(file.line), tonumber(file.col) - 1 })
        else
          -- handle multiple selections by sending them to quickfix
          local qf_entries = {}
          for _, selected_entry in ipairs(selected) do
            local parts = vim.fn.split(selected_entry, "\t")
            local symbol_name = parts[1]
            local selected_file = parts[2]
            local file_parts = vim.fn.split(selected_file, ":")
            table.insert(qf_entries, {
              filename = file_parts[1],
              lnum = file_parts[2],
              col = file_parts[3],
              text = symbol_name,
            })
          end
          vim.fn.setqflist(qf_entries)
          vim.cmd("copen")
        end
      end,
    },
  })
end

local function workspace_public_types(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Types❯ "
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols(
      "coding-flow workspace-symbols --language typescript --type type",
      opts
    )
  else
    require("fzf-lua").lsp_workspace_symbols(opts)
  end
end

local function workspace_public_functions(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Functions❯ "
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols(
      "coding-flow workspace-symbols --language typescript --type function",
      opts
    )
  else
    require("telescope.builtin").lsp_workspace_symbols({ symbols = { "function" } })
  end
end

local function workspace_public_variables(opts)
  opts = opts or {}
  if opts.prompt == nil then
    opts.prompt = "Variables❯ "
  end
  if require("ld.lsp.functions").is_typescript_workspace() then
    workspace_coding_flow_symbols(
      "coding-flow workspace-symbols --language typescript --type variable",
      opts
    )
  else
    require("telescope.builtin").lsp_workspace_symbols({ symbols = { "variable" } })
  end
end

require("fzf-lua").setup({
  -- use telescope profile as the base
  "telescope",
  winopts = {
    -- split = "botright new", -- open in a split instead?
    -- "belowright new"  : split below
    -- "aboveleft new"   : split above
    -- "belowright vnew" : split right
    -- "aboveleft vnew   : split left
    -- Only valid when using a float window
    -- (i.e. when 'split' is not defined)
    height = 0.55, -- window height
    width = 0.95, -- window width
    row = 0.88, -- window row position (0=top, 1=bottom)
    col = 0.50, -- window col position (0=left, 1=right)
    -- border argument passthrough to nvim_open_win(), also used
    -- to manually draw the border characters around the preview
    -- window, can be set to 'false' to remove all borders or to
    -- 'none', 'single', 'double' or 'rounded' (default)
    -- border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
    border = "single",
    fullscreen = false, -- start fullscreen?
    hl = {
      normal = "Normal", -- window normal color (fg+bg)
      border = "Normal", -- border color (try 'FloatBorder')
      -- Only valid with the builtin previewer:
      cursor = "Cursor", -- cursor highlight (grep/LSP matches)
      cursorline = "CursorLine", -- cursor line
      -- title       = 'Normal',        -- preview border title (file/buffer)
      -- scrollbar_f = 'PmenuThumb',    -- scrollbar "full" section highlight
      -- scrollbar_e = 'PmenuSbar',     -- scrollbar "empty" section highlight
    },
    preview = {
      -- default     = 'bat',           -- override the default previewer?
      -- default uses the 'builtin' previewer
      border = "border", -- border|noborder, applies only to
      -- native fzf previewers (bat/cat/git/etc)
      wrap = "nowrap", -- wrap|nowrap
      hidden = "nohidden", -- hidden|nohidden
      vertical = "down:45%", -- up|down:size
      horizontal = "right:50%", -- right|left:size
      layout = "flex", -- horizontal|vertical|flex
      flip_columns = 120, -- #cols to switch to horizontal on flex
      -- Only valid with the builtin previewer:
      title = true, -- preview border title (file/buf)?
      scrollbar = "float", -- `false` or string:'float|border'
      -- float:  in-window floating border
      -- border: in-border chars (see below)
      scrolloff = "-2", -- float scrollbar offset from right
      -- applies only when scrollbar = 'float'
      scrollchars = { "█", "" }, -- scrollbar chars ({ <full>, <empty> }
      -- applies only when scrollbar = 'border'
    },
    on_create = function()
      -- called once upon creation of the fzf main window
      -- can be used to add custom fzf-lua mappings, e.g:
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Down>",
      --     { silent = true, noremap = true })
    end,
  },
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<F4>"] = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      ["<S-down>"] = "preview-page-down",
      ["<S-up>"] = "preview-page-up",
      ["<S-left>"] = "preview-page-reset",
    },
    fzf = {
      -- fzf '--bind=' options
      ["ctrl-z"] = "abort",
      ["ctrl-u"] = "unix-line-discard",
      ["ctrl-f"] = "half-page-down",
      ["ctrl-b"] = "half-page-up",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",
      ["ctrl-q"] = "select-all+accept",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"] = "toggle-preview-wrap",
      ["f4"] = "toggle-preview",
      ["shift-down"] = "preview-page-down",
      ["shift-up"] = "preview-page-up",
    },
  },
  fzf_opts = {
    -- options are sent as `<left>=<right>`
    -- set to `false` to remove a flag
    -- set to '' for a non-value flag
    -- for raw args use `fzf_args` instead
    ["--ansi"] = "",
    ["--prompt"] = " >",
    ["--info"] = "inline",
    ["--height"] = "100%",
    ["--layout"] = "reverse",
    ["--tiebreak"] = "end,length",
  },
  previewers = {
    cat = { cmd = "cat", args = "--number" },
    bat = {
      cmd = "bat",
      args = "--style=numbers,changes --color always",
      theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
      config = nil, -- nil uses $BAT_CONFIG_PATH
    },
    head = { cmd = "head", args = nil },
    git_diff = { cmd = "git diff", args = "--color" },
    man = { cmd = "man -c %s | col -bx" },
    builtin = {
      delay = 100, -- delay(ms) displaying the preview
      -- prevents lag on fast scrolling
      syntax = true, -- preview syntax highlight?
      syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
      syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
    },
  },
  -- provider setup
  files = {
    -- previewer         = "cat",       -- uncomment to override previewer
    prompt = "Files❯ ",
    winopts = { preview = { hidden = "hidden" } },
    git_icons = false, -- show git icons?
    file_icons = true, -- show file icons?
    color_icons = true, -- colorize file|git icons
    actions = {
      -- set bind to 'false' to disable
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      -- custom actions are available too
      ["ctrl-y"] = function(selected)
        print(selected[1])
      end,
    },
  },
  git = {
    files = {
      prompt = "GitFiles❯ ",
      cmd = "git ls-files --exclude-standard",
      git_icons = true, -- show git icons?
      file_icons = true, -- show file icons?
      color_icons = true, -- colorize file|git icons
      winopts = { height = 0.95 },
      actions = {
        ["default"] = actions.file_edit,
        ["ctrl-s"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-t"] = actions.file_tabedit,
        ["ctrl-q"] = actions.file_sel_to_qf,
      },
    },
    status = {
      prompt = "GitStatus❯ ",
      cmd = "git status -s",
      previewer = "git_diff",
      file_icons = true,
      git_icons = true,
      color_icons = true,
    },
    commits = {
      prompt = "Commits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = { ["default"] = actions.git_checkout },
    },
    bcommits = {
      prompt = "BCommits❯ ",
      cmd = "git log --pretty=oneline --abbrev-commit --color",
      preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
      actions = {
        ["default"] = actions.git_buf_edit,
        ["ctrl-s"] = actions.git_buf_split,
        ["ctrl-v"] = actions.git_buf_vsplit,
        ["ctrl-t"] = actions.git_buf_tabedit,
      },
    },
    branches = {
      prompt = "Branches❯ ",
      cmd = "git branch --all --color",
      preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
      actions = { ["default"] = actions.git_switch },
    },
    icons = {
      ["M"] = { icon = "M", color = "yellow" },
      ["D"] = { icon = "D", color = "red" },
      ["A"] = { icon = "A", color = "green" },
      ["?"] = { icon = "?", color = "magenta" },
      -- ["M"]          = { icon = "★", color = "red" },
      -- ["D"]          = { icon = "✗", color = "red" },
      -- ["A"]          = { icon = "+", color = "green" },
    },
  },
  grep = {
    prompt = "Rg❯ ",
    input_prompt = "Grep For❯ ",
    -- cmd               = "rg --vimgrep",
    rg_opts = "--hidden --column --line-number --no-heading "
      .. "--color=always --smart-case -g '!{.git,node_modules}/*'",
    git_icons = true, -- show git icons?
    file_icons = true, -- show file icons?
    color_icons = true, -- colorize file|git icons
    -- 'true' enables file and git icons in 'live_grep'
    -- degrades performance in large datasets, YMMV
    experimental = false,
    -- live_grep_glob options
    glob_flag = "--iglob", -- for case sensitive globs use '--glob'
    glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
  },
  args = {
    prompt = "Args❯ ",
    files_only = true,
    actions = {
      -- added on top of regular file actions
      ["ctrl-x"] = actions.arg_del,
    },
  },
  oldfiles = { prompt = "History❯ ", cwd_only = false },
  buffers = {
    -- previewer      = false,        -- disable the builtin previewer?
    prompt = "Buffers❯ ",
    file_icons = true, -- show file icons?
    color_icons = true, -- colorize file|git icons
    sort_lastused = true, -- sort buffers() by last used
    actions = {
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
      ["ctrl-x"] = actions.buf_del,
    },
  },
  blines = {
    previewer = "builtin", -- set to 'false' to disable
    prompt = "BLines❯ ",
    actions = {
      ["default"] = actions.buf_edit,
      ["ctrl-s"] = actions.buf_split,
      ["ctrl-v"] = actions.buf_vsplit,
      ["ctrl-t"] = actions.buf_tabedit,
    },
  },
  colorschemes = {
    prompt = "Colorschemes❯ ",
    live_preview = true, -- apply the colorscheme on preview?
    actions = {
      ["default"] = actions.colorscheme,
      ["ctrl-y"] = function(selected)
        print(selected[1])
      end,
    },
    winopts = { height = 0.55, width = 0.30 },
    post_reset_cb = function()
      -- reset statusline highlights after
      -- a live_preview of the colorscheme
      -- require('feline').reset_highlights()
    end,
  },
  quickfix = {
    -- cwd               = vim.loop.cwd(),
    file_icons = true,
    git_icons = true,
  },
  lsp = {
    prompt = "❯ ",
    -- cwd               = vim.loop.cwd(),
    cwd_only = false, -- LSP/diagnostics for cwd only?
    async_or_timeout = true, -- timeout(ms) or false for blocking calls
    file_icons = true,
    git_icons = false,
    lsp_icons = true,
    severity = "hint",
    icons = {
      ["Error"] = { icon = "", color = "red" }, -- error
      ["Warning"] = { icon = "", color = "yellow" }, -- warning
      ["Information"] = { icon = "", color = "blue" }, -- info
      ["Hint"] = { icon = "", color = "magenta" }, -- hint
    },
  },
  file_icon_padding = "",
  file_icon_colors = { ["lua"] = "blue" },
})

local M = {}
M.files = files
M.workspace_public_types = workspace_public_types
M.workspace_public_functions = workspace_public_functions
M.workspace_public_variables = workspace_public_variables

return M
