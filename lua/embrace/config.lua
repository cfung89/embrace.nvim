local M = {}

M.defaults = {
	keymaps = {
		surround = "S",
		surround_block = "B",
		block = "<leader>BB",
		str = "S",
	},
	surround_map = {},
	surround_block_map = nil,
}

---@param opts table | nil
---@return nil
M.set = function(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("force", M.defaults, opts)

	opts.surround_map = opts.surround_map or {}
	for i, key in ipairs(opts.surround_map) do
		assert(#key == 3, "Assertion Error: Invalid number of keys.")
		assert(type(key[1]) == "string" and #key[1] == 1,
			string.format("Assertion Error: Invalid key for surround_map at index [%d][2].", i))
		assert(type(key[2]) == "string", "Assertion Error: Invalid key for surround_map.")
		assert(type(key[3]) == "string", "Assertion Error: Invalid key for surround_map.")
	end
	M.opts.surround_map = opts.surround_map

	if opts.surround_block_map == nil then
		M.opts.surround_block_map = M.opts.surround_map
		return
	end

	for i, key in ipairs(opts.surround_block_map) do
		assert(#key == 3, "Assertion Error: Invalid number of keys.")
		assert(type(key[1]) == "string" and #key[1] == 1,
			string.format("Assertion Error: Invalid key for surround_map at index [%d][2].", i))
		assert(type(key[2]) == "string", "Assertion Error: Invalid key for surround_block_map.")
		assert(type(key[3]) == "string", "Assertion Error: Invalid key for surround_block_map.")
	end
	M.opts.surround_block_map = opts.surround_block_map
end

return M
