local fzf = require("fzf").fzf

local normalize_opts = function(opts)
	if not opts then
		opts = {}
	end
	if not opts.fzf then
		opts.fzf = require("fzf").fzf
	end
	return opts
end

local files = function(opts)
	if not require("ld.utils.functions").is_windows() then
		require("fzf-lua").files(opts)
	else
		opts = normalize_opts(opts)
		local command
		if vim.fn.executable("fd") == 1 then
			command = "fd --color always -t f -L"
		else
			-- tail to get rid of current directory from the results
			command = "find . -type f -printf '%P\n' | tail +2"
		end

		coroutine.wrap(function()
			local choices = opts.fzf(
				command,
				"--info=inline --layout=reverse --tiebreak=end,length --ansi --expect=ctrl-s,ctrl-t,ctrl-v --multi",
				{ height = 22, row = 46 }
			)

			if not choices then
				return
			end

			local vimcmd
			if choices[1] == "ctrl-t" then
				vimcmd = "tabnew"
			elseif choices[1] == "ctrl-v" then
				vimcmd = "vnew"
			elseif choices[1] == "ctrl-s" then
				vimcmd = "new"
			else
				vimcmd = "e"
			end

			for i = 2, #choices do
				vim.cmd(vimcmd .. " " .. vim.fn.fnameescape(choices[i]))
			end
		end)()
	end
end

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
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
		cmd = "fdfind . --type f", -- "find . -type f -printf '%P\n'",
		git_icons = true, -- show git icons?
		file_icons = true, -- show file icons?
		color_icons = true, -- colorize file|git icons
		actions = {
			-- set bind to 'false' to disable
			["default"] = actions.file_edit,
			["ctrl-s"] = actions.file_split,
			["ctrl-v"] = actions.file_vsplit,
			["ctrl-t"] = actions.file_tabedit,
			["alt-q"] = actions.file_sel_to_qf,
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
return M
