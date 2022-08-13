local saga = require("lspsaga")

saga.init_lsp_saga({
	use_saga_diagnostic_sign = false,
	finder_definition_icon = " ",
	finder_reference_icon = " ",
	rename_prompt_prefix = "",
	rename_prompt_populate = true,
	code_action_prompt = { enable = false },
})
