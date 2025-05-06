local utils = require("embrace.utils")
local config = require("embrace.config")

local M = {}

---@param opening string
---@param closing string
---@param range table
local insert_surround = function(opening, closing, range)
	utils.validate_range(range)
	local row0, col0 = utils.unpack(range[1])
	local row1, col1 = utils.unpack(range[2])
	utils.insert(closing, row1 - 1, col1)
	utils.insert(opening, row0 - 1, col0 - 1)
end

---@param opening string
---@param closing string
---@param range table
local iter_surround_block = function(opening, closing, range)
	utils.validate_range(range)
	local row0, col0 = utils.unpack(range[1])
	local row1, col1 = utils.unpack(range[2])
	local abs_starting = utils.get_abs_pos(vim.api.nvim_buf_get_lines(0, row0 - 1, row0, false)[1] or "", col0)
	local abs_ending = utils.get_abs_pos(vim.api.nvim_buf_get_lines(0, row1 - 1, row1, false)[1] or "", col1)
	for i = row0, row1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
		local rel_starting = utils.get_relative_pos(line, abs_starting)
		local rel_ending = utils.get_relative_pos(line, abs_ending)
		insert_surround(opening, closing, { { i, rel_starting }, { i, rel_ending } })
	end
end

---Surround Visual Block mode range with the given character or use additional functionality.
---@param char string | nil
---@return nil
local surround_block = function(char)
	char = char or utils.get_input()
	if char == "" then
		return
	end

	local range = utils.get_visual()
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
		[config.opts.keymaps.str] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				if string.sub(input, 2, 2) == "/" then
					iter_surround_block(string.sub(input, 1, 1) .. string.sub(input, 3), input, range)
				else
					iter_surround_block(input, string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), range)
				end
			else
				iter_surround_block(input, input, range)
			end
		end,
		default = function()
			iter_surround_block(char, char, range)
		end,
	}
	utils.switch(char, surround_map, true)
end

---Surround Visual mode range with the given character or use additional functionality.
---@param char string | nil
---@return nil
M.surround = function(char)
	char = char or utils.get_input()
	if char == "" then
		return
	end
	local range = utils.get_visual()
	utils.validate_range(range)

	-- top left to bottom right
	local row0, col0 = utils.unpack(range[1])
	local row1, col1 = utils.unpack(range[2])
	if row0 > row1 or (row0 == row1 and col0 > col1) then
		row0, row1 = row1, row0
		col0, col1 = col1, col0
	end
	range = { { row0, col0 }, { row1, col1 } }
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
		[config.opts.keymaps.block] = function()
			local newC = utils.get_input()
			if newC == "" then
				return
			end
			surround_block(newC)
		end,
		[config.opts.keymaps.str] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				if string.sub(input, 2, 2) == "/" then
					iter_surround_block(string.sub(input, 1, 1) .. string.sub(input, 3), input, range)
				else
					insert_surround(input, string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), range)
				end
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
