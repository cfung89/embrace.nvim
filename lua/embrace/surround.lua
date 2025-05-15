local utils = require("embrace.utils")
local config = require("embrace.config")

local M = {}

---Surround Visual Block mode range with the given character or use additional functionality.
---@param char string?
---@return nil
M.surround_block = function(char)
	char = char or utils.get_input()
	if char == "" then
		return
	end

	local range = utils.get_visual()
	local surround_map = {
		["("] = function()
			utils.insert_surround_block("( ", " )", range)
		end,
		[")"] = function()
			utils.insert_surround_block("(", ")", range)
		end,
		["["] = function()
			utils.insert_surround_block("[ ", " ]", range)
		end,
		["]"] = function()
			utils.insert_surround_block("[", "]", range)
		end,
		["{"] = function()
			utils.insert_surround_block("{ ", " }", range)
		end,
		["}"] = function()
			utils.insert_surround_block("{", "}", range)
		end,
		["<"] = function()
			utils.insert_surround_block("< ", " >", range)
		end,
		[">"] = function()
			utils.insert_surround_block("<", ">", range)
		end,
		[config.opts.keymaps.str] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				if string.sub(input, 2, 2) == "/" then
					utils.insert_surround_block(string.sub(input, 1, 1) .. string.sub(input, 3), input, range)
				else
					utils.insert_surround_block(input, string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), range)
				end
			else
				utils.insert_surround_block(input, input, range)
			end
		end,
		default = function()
			utils.insert_surround_block(char, char, range)
		end,
	}
	for _, key in ipairs(config.opts.surround_block_map) do
		surround_map[key[1]] = function()
			utils.insert_surround_block(key[2], key[3], range)
		end
	end
	utils.switch(char, surround_map, true)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

---Surround Visual mode range with the given character or use additional functionality.
---@param char string?
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
			utils.insert_surround("( ", " )", range)
		end,
		[")"] = function()
			utils.insert_surround("(", ")", range)
		end,
		["["] = function()
			utils.insert_surround("[ ", " ]", range)
		end,
		["]"] = function()
			utils.insert_surround("[", "]", range)
		end,
		["{"] = function()
			utils.insert_surround("{ ", " }", range)
		end,
		["}"] = function()
			utils.insert_surround("{", "}", range)
		end,
		["<"] = function()
			utils.insert_surround("< ", " >", range)
		end,
		[">"] = function()
			utils.insert_surround("<", ">", range)
		end,
		[config.opts.keymaps.surround_block] = function()
			local newC = utils.get_input()
			if newC == "" then
				return
			end
			M.surround_block(newC)
		end,
		[config.opts.keymaps.str] = function()
			local input = vim.fn.input("Enter input: ")
			if string.sub(input, 1, 1) == "<" and string.sub(input, -1) == ">" then
				if string.sub(input, 2, 2) == "/" then
					utils.insert_surround_block(string.sub(input, 1, 1) .. string.sub(input, 3), input, range)
				else
					utils.insert_surround(input, string.sub(input, 1, 1) .. "/" .. string.sub(input, 2), range)
				end
			else
				utils.insert_surround(input, input, range)
			end
		end,
		default = function()
			utils.insert_surround(char, char, range)
		end,
	}
	for _, key in ipairs(config.opts.surround_map) do
		surround_map[key[1]] = function()
			utils.insert_surround_block(key[2], key[3], range)
		end
	end
	utils.switch(char, surround_map, true)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

return M
