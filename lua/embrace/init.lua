local config = require("embrace.config")

local M = {}

---@param opts table?
M.setup = function(opts)
	config.set(opts)

	if config.opts.keymaps.surround then
		vim.keymap.set("v", config.opts.keymaps.surround, require("embrace.surround").surround)
	end
	if config.opts.keymaps.block then
		vim.keymap.set("v", config.opts.keymaps.block, require("embrace.surround").surround_block)
	end
end

return M
