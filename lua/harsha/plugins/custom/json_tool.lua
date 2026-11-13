return {
	dir = vim.fn.stdpath("config"),
	name = "my-json-tool",

	keys = {
		{
			"<leader>fj",
			function()
				require("harsha.tools.json-format").format_json()
			end,
			desc = "format json buffer",
			ft = "json",
		},
	},
}
