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

---Insert text at specific coordinates
---@param input string
---@param row integer
---@param col integer
M.insert = function(input, row, col)
	if not pcall(vim.api.nvim_buf_set_text, 0, row, col, row, col, { input }) then
		vim.api.nvim_buf_set_text(0, row, col - 1, row, col - 1, { input })
	end
end

---Get absolute position, regardless of tabs.
---@param line string
---@param cursor integer
---@return integer
M.get_abs_pos = function(line, cursor)
	local space_pos = 0
	local end_pos = (cursor < #line) and cursor or #line
	local tabwidth = vim.api.nvim_get_option_value("tabstop", { buf = 0 })
	for i = 1, end_pos do
		local char = line:sub(i, i)
		local length = 1
		if char == "\t" then
			length = tabwidth - (space_pos % tabwidth)
		end
		space_pos = space_pos + length
	end
	return space_pos
end

---Gets coordinates of Visual mode selection
---@return table
M.get_visual = function()
	local _, row0, col0 = unpack(vim.fn.getpos("v"))
	local _, row1, col1 = unpack(vim.fn.getpos("."))
	M.get_visual_block()
	return { { row0, col0 }, { row1, col1 } }
end

---Gets coordinates of Visual block mode selection
---@return table
M.get_visual_block = function()
	local _, row0, col0 = unpack(vim.fn.getpos("v"))
	local _, row1, col1 = unpack(vim.fn.getpos("."))

	local line = vim.api.nvim_get_current_line()
	local starting = M.get_abs_pos(line, col0)
	local ending = M.get_abs_pos(line, col1)
	return { { row0, col0, starting }, { row1, col1, ending } }
end

return M
