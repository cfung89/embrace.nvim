local M = {}
local utils = require("embrace.utils")

---@param opening string
---@param closing string
---@param range table
local insert_surround = function(opening, closing, range)
	utils.validate_range(range)
	local row0, col0 = unpack(range[1])
	local row1, col1 = unpack(range[2])
	utils.insert(closing, row1 - 1, col1)
	utils.insert(opening, row0 - 1, col0 - 1)
end

---@param opening string
---@param closing string
---@param range table
local iter_surround_block = function(opening, closing, range)
	utils.validate_range(range)
	local row0, col0 = unpack(range[1])
	local row1, col1 = unpack(range[2])
	for i = row0, row1 do
		insert_surround(opening, closing, { { i, col0 }, { i, col1 } })
	end
end

---Surround Visual Block mode selection with the given character or use additional functionality.
---@param char string
---@param range table
---@return function
local surround_block = function(char, range)
	utils.validate_range(range)
	local row0, col0 = unpack(range[1])
	local row1, col1 = unpack(range[2])
	if row0 > row1 then
		row0, row1 = row1, row0
	end
	if col0 > col1 then
		col0, col1 = col1, col0
	end
	range = { { row0, col0 }, { row1, col1 } }
	local surround_map = {
		["("] = function()
			iter_surround_block("( ", " )", range)
		end,
		[")"] = function()
			iter_surround_block("(", ")", range)
		end,
		["["] = function()
			iter_surround_block("[ ", " ]", range)
		end,
		["]"] = function()
			iter_surround_block("[", "]", range)
		end,
		["{"] = function()
			iter_surround_block("{ ", " }", range)
		end,
		["}"] = function()
			iter_surround_block("{", "}", range)
		end,
		["<"] = function()
			iter_surround_block("< ", " >", range)
		end,
		[">"] = function()
			iter_surround_block("<", ">", range)
		end,
		["S"] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				iter_surround_block(input, string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), range)
			else
				iter_surround_block(input, input, range)
			end
		end,
		default = function()
			iter_surround_block(char, char, range)
		end,
	}
	return utils.switch(char, surround_map, true)
end

---Surround Visual mode selection with the given character or use additional functionality.
---@param char string | nil
M.surround = function(char)
	char = char or utils.get_input()
	if char == "" then
		return
	end
	local selection = utils.get_visual()
	utils.validate_range(selection)

	-- top left to bottom right
	local row0, col0 = unpack(selection[1])
	local row1, col1 = unpack(selection[2])
	if row0 > row1 or (row0 == row1 and col0 > col1) then
		row0, row1 = row1, row0
		col0, col1 = col1, col0
	end
	local range = { { row0, col0 }, { row1, col1 } }
	local surround_map = {
		["("] = function()
			insert_surround("( ", " )", range)
		end,
		[")"] = function()
			insert_surround("(", ")", range)
		end,
		["["] = function()
			insert_surround("[ ", " ]", range)
		end,
		["]"] = function()
			insert_surround("[", "]", range)
		end,
		["{"] = function()
			insert_surround("{ ", " }", range)
		end,
		["}"] = function()
			insert_surround("{", "}", range)
		end,
		["<"] = function()
			insert_surround("< ", " >", range)
		end,
		[">"] = function()
			insert_surround("<", ">", range)
		end,
		["B"] = function()
			local newC = utils.get_input()
			if newC == "" then
				return
			end
			return surround_block(newC, selection)
		end,
		["S"] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				utils.insert(string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), row1 - 1, col1)
				utils.insert(input, row0 - 1, col0 - 1)
			else
				insert_surround(input, input, range)
			end
		end,
		default = function()
			insert_surround(char, char, range)
		end,
	}
	utils.switch(char, surround_map, true)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

return M
