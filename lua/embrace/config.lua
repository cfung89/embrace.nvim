local M = {}

M.defaults = {
	keymaps = {
		surround = "S",
		block = "B",
		str = "S",
	},
}

M.set = function(opts)
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

-- M.surround_map = {}

-- M.set_surround_map = function(opts)
-- 	for key, func in pairs(opts) do
-- 		assert(type(key) ~= "string" and #key ~= 1, "Assertion Error: Invalid key for surround_map.")
-- 		assert(type(func) ~= "function", "Assertion Error: Invalid key for surround_map.")
-- 	end
-- 	M.surround_map = vim.tbl_deep_extend("force", M.surround_map, opts or {})
-- end

return M
