local M = {}

M.unpack = unpack or table.unpack

---Switch function.
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
	assert(type(c) == "number", "Assertion Error: Invalid input character.")
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
---@param cursor integer 0-indexed cursor position (as given by Neovim)
---@return integer
M.get_abs_pos = function(line, cursor)
	local space_pos = 0
	local end_pos = math.min(#line, cursor)
	local tab_width = vim.api.nvim_get_option_value("tabstop", { buf = 0 })
	for i = 1, end_pos do
		local char = line:sub(i, i)
		local length = 1
		if char == "\t" then
			length = tab_width - (space_pos % tab_width)
		end
		space_pos = space_pos + length
	end
	return space_pos
end

---Get relative position, regardless of tabs.
---@param line string
---@param space_pos integer
---@return integer
M.get_relative_pos = function(line, space_pos)
	local pos = 0
	local tab_width = vim.api.nvim_get_option_value("tabstop", { buf = 0 })
	for i = 1, #line do
		local char = line:sub(i, i)
		local length = 1
		if char == "\t" then
			length = tab_width - (pos % tab_width)
		end
		if pos + length > space_pos then
			return i - 1
		end
		pos = pos + length
	end
	return #line
end

---Gets coordinates of Visual mode selection
---@return table
M.get_visual = function()
	local _, row0, col0 = M.unpack(vim.fn.getpos("v"))
	local _, row1, col1 = M.unpack(vim.fn.getpos("."))
	return { { row0, col0 }, { row1, col1 } }
end

---@param opening string
---@param closing string
---@param range table
---@return nil
M.insert_surround = function(opening, closing, range)
	M.validate_range(range)
	local row0, col0 = M.unpack(range[1])
	local row1, col1 = M.unpack(range[2])
	M.insert(closing, row1 - 1, col1)
	M.insert(opening, row0 - 1, col0 - 1)
end

---@param opening string
---@param closing string
---@param range table
---@return nil
M.insert_surround_block = function(opening, closing, range)
	M.validate_range(range)
	local row0, col0 = M.unpack(range[1])
	local row1, col1 = M.unpack(range[2])
	local abs_starting = M.get_abs_pos(vim.api.nvim_buf_get_lines(0, row0 - 1, row0, false)[1] or "", col0)
	local abs_ending = M.get_abs_pos(vim.api.nvim_buf_get_lines(0, row1 - 1, row1, false)[1] or "", col1)
	for i = row0, row1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
		local rel_starting = M.get_relative_pos(line, abs_starting)
		local rel_ending = M.get_relative_pos(line, abs_ending)
		M.insert_surround(opening, closing, { { i, rel_starting }, { i, rel_ending } })
	end
end

return M
