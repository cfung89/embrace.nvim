local M = {}

M.defaults = {
	keymaps = {
		surround = "S",
		block = "B",
		str = "S",
	},
	cmd = "Surround",
}

M.set = function(opts)
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
