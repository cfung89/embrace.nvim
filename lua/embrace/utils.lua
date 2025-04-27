local M = {}

---Switch function
---@param x string
---@param cases table
---@param run boolean
---@return function
M.switch = function(x, cases, run)
	local match = cases[x] or cases.default or function() end
	if run then
		match()
	end
	return match
end

--- Validates that a range has exactly two positions, each containing two elements (row, col).
---@param range (table) A table containing two position tables:
---  - `range[1]` is the start position `{row, col}`.
---  - `range[2]` is the end position `{row, col}`.
---@return boolean
M.validate_range = function(range)
	assert(range ~= nil, "Assertion Error: range is nil")
	assert(#range == 2, "Assertion Error: range must contain exactly two positions")
	assert(#range[1] == 2, "Assertion Error: range[1] must contain exactly two positions")
	assert(#range[2] == 2, "Assertion Error: range[2] must contain exactly two positions")
	return true
end

---Get user input character.
---@return string
M.get_input = function()
	local success, c = pcall(vim.fn.getchar)
	if not success then
		return ""
	end
	if type(c) ~= "number" then
		vim.print("Invalid input character.")
		return ""
	end
	return string.char(c)
end

---Gets coordinates of Visual mode selection
---@return table
M.get_visual = function()
	local _, row0, col0 = unpack(vim.fn.getpos("v"))
	local _, row1, col1 = unpack(vim.fn.getpos("."))
	return { { row0, col0 }, { row1, col1 } }
end

---Insert text at specific coordinates
---@param input string
---@param row integer
---@param col integer
M.insert = function(input, row, col)
	if not pcall(vim.api.nvim_buf_set_text, 0, row, col, row, col, { input }) then
		vim.api.nvim_buf_set_text(0, row, col - 1, row, col - 1, { input })
	end
end

return M
