local null_ls = require("null-ls")
local lsp = require("lspconfig")

null_ls.setup({
	on_attach = function(client, bufnr)
		require("ld.lsp.remaps").set_default(client, bufnr)
	end,
	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.cspell.with({
			filetypes = {},
			severity = vim.diagnostic.severity.INFO,
			disabled_filetypes = { "lua", "vim", "gitconfig", "vimwiki" },
			extra_args = function(params)
				if lsp.util.root_pattern(".vscode/cspell.json")(params.bufname) then
					return params.options and { "--config", ".vscode/cspell.json" }
				end
				return params.options
			end,

			cwd = function(params)
				local cwd = lsp.util.root_pattern("tsconfig.json")(params.bufname)
					or lsp.util.root_pattern(".vscode/")(params.bufname)
					or lsp.util.root_pattern("package.json", ".git/", ".zshrc")(params.bufname)
					or lsp.util.path.dirname(params.bufname)
				return cwd
			end,
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,
	},
	debounce = 600,
})
